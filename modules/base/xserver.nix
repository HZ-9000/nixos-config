{ ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    libinput = {
      enable = true;
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
