{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "parallels";

  system.stateVersion = "26.05";
}
