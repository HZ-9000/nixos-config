{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
  ];

  networking.hostName = "storm";

  system.stateVersion = "26.05";
}
