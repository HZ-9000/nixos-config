{ pkgs, ... }:
{
  # Note: networking.hostName is set per-host in hosts/<name>/default.nix
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
