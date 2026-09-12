{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./amd-hardware.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  networking.hostName = "storm";

  modules.desktop.gaming.enable = true;

  system.stateVersion = "26.05";
}
