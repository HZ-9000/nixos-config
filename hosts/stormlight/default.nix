{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
