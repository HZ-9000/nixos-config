{
  config,
  myvars,
  pkgs,
  ...
}:
let
  configDir = "${config.home.homeDirectory}/${myvars.configDirectoryName}/home/linux/gui/hyprland/config";
in
{
  home.packages = with pkgs; [
    grim
    playerctl
    satty
    slurp
  ];

  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/hyprland.lua";

  systemd.user.services.hyprland-polkit = {
    Unit = {
      Description = "PolicyKit authentication agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  home.file.".wayland-session" = {
    source = pkgs.writeShellScript "start-wayland-session" ''
      exec ${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop
    '';
    executable = true;
  };
}
