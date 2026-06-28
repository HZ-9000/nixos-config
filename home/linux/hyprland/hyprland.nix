{ inputs, lib, pkgs, config, ... }:
let
  hyprConfigDir = "${config.xdg.configHome}/hypr";
in
{
  home.packages = with pkgs; [
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };

  # Hyprland is installed at system level (package = null), so home-manager does
  # not reload config on switch. Remove stale unmanaged files first, then reload.
  home.activation = {
    hyprlandConfigCleanup = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p ${hyprConfigDir}
      $DRY_RUN_CMD rm -f ${hyprConfigDir}/hyprland.conf
      if [ -e ${hyprConfigDir}/hyprland.lua ] \
        && { [ ! -L ${hyprConfigDir}/hyprland.lua ] \
          || ! readlink ${hyprConfigDir}/hyprland.lua | grep -q '^/nix/store/'; }; then
        $DRY_RUN_CMD rm -f ${hyprConfigDir}/hyprland.lua
      fi
    '';

    hyprlandConfigReload = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v hyprctl >/dev/null 2>&1 \
        && { [ -d /tmp/hypr ] || [ -d "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr" ]; }; then
        $DRY_RUN_CMD hyprctl reload config-only 2>/dev/null || true
      fi
    '';
  };
}
