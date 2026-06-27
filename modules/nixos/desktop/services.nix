{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    tumbler.enable = true; # thumbnail generation for file managers

    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };

    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };

    fstrim.enable = true;
    fwupd.enable = true;

    logind.settings.Login = {
      HandlePowerKey = "ignore";
    };

    # openssh is configured in modules/nixos/base/ssh.nix — do not duplicate here
  };

  # File manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
