{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  modules.desktop.gaming.enable = true;

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
