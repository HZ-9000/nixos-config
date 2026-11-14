{ pkgs, ... }:
let
  # Noctalia's bar panel pairs by calling org.bluez Device.Pair() on the
  # default 25s D-Bus timeout. For a BLE keyboard that call does not return
  # until the whole passkey handshake is done — host shows six digits, you type
  # them on the device, you press enter — which routinely runs past 25s. The
  # call then dies with org.freedesktop.DBus.Error.NoReply *mid-handshake* and
  # the device never bonds. (Observed with an MX Keys Mini: handshake took 21s
  # once it did work.) bt-pair drives the same flow from the CLI, where nothing
  # is racing a client-side timeout.
  bt-pair = pkgs.writeShellApplication {
    name = "bt-pair";
    runtimeInputs = with pkgs; [
      bluez
      bluez-tools
      coreutils
      gawk
      gnugrep
      systemd
    ];
    text = ''
      target="''${1:-}"
      agent_pid=""
      scan_pid=""

      cleanup() {
        [ -n "$agent_pid" ] && kill "$agent_pid" 2>/dev/null || true
        [ -n "$scan_pid" ] && kill "$scan_pid" 2>/dev/null || true
        # bt-agent grabbed the default-agent slot off the shell. Hand it back,
        # otherwise device-initiated pairing has no agent to answer it.
        if systemctl --user is-active --quiet noctalia.service; then
          systemctl --user try-restart noctalia.service || true
        fi
      }
      trap cleanup EXIT

      # DisplayOnly = we print the passkey, the remote keyboard types it. That is
      # the IO capability a Logitech MX-series keyboard expects; it makes BlueZ
      # pick "Passkey Entry, initiator displays" instead of a confirm-only flow.
      echo ":: registering pairing agent (DisplayOnly)"
      bt-agent -c DisplayOnly &
      agent_pid=$!
      sleep 1

      echo ":: scanning — put the device into pairing mode now"
      echo "   (MX Keys Mini: hold a 1/2/3 channel key until its LED blinks fast)"
      bluetoothctl --timeout 300 scan le >/dev/null 2>&1 &
      scan_pid=$!

      # Devices with no advertised name show up as their own MAC with dashes;
      # they are never what you are trying to pair, so drop them from the list.
      named_devices() {
        bluetoothctl devices \
          | sed 's/\x1b\[[0-9;]*m//g' \
          | awk '{ mac=$2; name=""; for (i=3;i<=NF;i++) name=name (i>3?" ":"") $i;
                   gsub(/:/,"-",mac); if (name != mac) print }'
      }

      mac=""
      if [ -n "$target" ]; then
        echo ":: waiting for a device matching \"$target\""
        for _ in $(seq 1 60); do
          mac=$(named_devices | grep -i -- "$target" | head -1 | awk '{print $2}')
          [ -n "$mac" ] && break
          sleep 2
        done
        if [ -z "$mac" ]; then
          echo "!! nothing matching \"$target\" showed up" >&2
          exit 1
        fi
      else
        sleep 20
        mapfile -t devs < <(named_devices)
        if [ "''${#devs[@]}" -eq 0 ]; then
          echo "!! no named devices found" >&2
          exit 1
        fi
        for i in "''${!devs[@]}"; do
          printf '%3d) %s\n' "$((i + 1))" "''${devs[i]#Device }"
        done
        read -r -p "pair which? " n
        mac=$(echo "''${devs[$((n - 1))]}" | awk '{print $2}')
      fi

      name=$(named_devices | grep -i -- "$mac" | head -1 | awk '{for (i=3;i<=NF;i++) printf "%s%s", (i>3?" ":""), $i}')
      echo ":: pairing $name ($mac) — the passkey will print below"

      if ! bluetoothctl pair "$mac"; then
        echo "!! pair failed" >&2
        exit 1
      fi

      # trust so it reconnects on its own after a reboot or power cycle
      bluetoothctl trust "$mac"
      bluetoothctl connect "$mac"
      echo ":: done — $name is paired, trusted and connected"
    '';
  };
in
{
  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluetui
    bluez-tools
    bt-pair
  ];
}
