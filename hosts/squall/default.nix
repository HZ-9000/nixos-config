{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "squall";

  system.stateVersion = "26.05";
}
