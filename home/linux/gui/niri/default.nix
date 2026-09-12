{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    xwayland-satellite

    slurp
    grim
    satty
  ];

  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nixos-config/home/linux/gui/niri/conf";
    in
    {
      "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
      "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
      "niri/spawn-at-startup.kdl".source = mkSymlink "${confPath}/spawn-at-startup.kdl";
      "niri/key-bindings.kdl".source = mkSymlink "${confPath}/key-bindings.kdl";
      "niri/window-rules.kdl".source = mkSymlink "${confPath}/window-rules.kdl";
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
