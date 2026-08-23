{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
  ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
