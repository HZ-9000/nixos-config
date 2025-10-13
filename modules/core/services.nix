{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;

    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };

    dbus.enable = true;
    fstrim.enable = true;

    fwupd.enable = true;
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    logind.settings.Login = {
      # don’t shutdown when power button is short-pressed
      HandlePowerKey = "ignore";
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
	PermitRootLogin = "no";
	AllowUsers = [ "delta" ];
      };
    };
  };
}
