{ ... }:
let
  browser = "zen-beta";
  terminal = "ghostty";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      # autostart
      exec-once = [
        # "hash dbus-update-activation-environment 2>/dev/null"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "nm-applet &"
        #"poweralertd &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        #"waybar &"
        #"swaync &"
        #"vicinae server &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        #"swww-daemon &"

        "hyprlock"

        "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
        "[workspace 1 silent] ${browser}"
        "[workspace 2 silent] ${terminal}"
      ];

      monitor = [ "=,preferred,auto,auto" ];

      xwayland = {
        force_zero_scaling = true;
      };
    };
  };
}
