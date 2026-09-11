{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  networking.hostName = "storm";

  system.stateVersion = "26.05";
}
