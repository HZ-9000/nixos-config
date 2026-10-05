{
  pkgs,
  config,
  osConfig,
  myvars,
  ...
}:
let
  hostName = osConfig.networking.hostName;
in
{
  assertions = [
    {
      assertion = builtins.pathExists (./conf/monitors + "/${hostName}.kdl");
      message = "niri: no display layout for host '${hostName}', create home/linux/gui/niri/conf/monitors/${hostName}.kdl";
    }
  ];

  home.packages = with pkgs; [
    xwayland-satellite

    nwg-displays # GUI display arranger, writes ~/.config/niri/monitor.kdl

    slurp
    grim
    satty
  ];

  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/${myvars.configDirectoryName}/home/linux/gui/niri/conf";
    in
    {
      "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
      "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
      "niri/spawn-at-startup.kdl".source = mkSymlink "${confPath}/spawn-at-startup.kdl";
      "niri/key-bindings.kdl".source = mkSymlink "${confPath}/key-bindings.kdl";
      "niri/window-rules.kdl".source = mkSymlink "${confPath}/window-rules.kdl";

      # Display arrangement is per-host and is meant to be rewritten at runtime
      # by nwg-displays, so it points at a tracked file instead of the store.
      "niri/monitor.kdl".source = mkSymlink "${confPath}/monitors/${hostName}.kdl";
    };

  systemd.user.services.niri-flake-polkit = {
    Unit = {
      Description = "PolicyKit Authentication Agent provided by niri-flake";
      After = [
        "graphical-session.target"
      ];
      Wants = [ "graphical-session-pre.target" ];
    };
    Install.WantedBy = [ "niri.service" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      # trying to stop a previous niri session
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      # and then we start a new one
      /run/current-system/sw/bin/niri-session
    '';
    executable = true;
  };
}
