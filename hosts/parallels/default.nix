{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
  ];

  networking.hostName = "parallels";

  system.stateVersion = "26.05";
}
