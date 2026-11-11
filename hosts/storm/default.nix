# Machine-level settings only (hardware, disk, preservation). The installer flake imports
# this file too, so desktop policy belongs in modules/nixos/desktop.nix.
{ disko, ... }:
{
  imports = [
    disko.nixosModules.disko
    ./hardware-configuration.nix
    ./amd-hardware.nix
    ./disko-fs.nix
    ../common/preservation.nix
  ];

  # Keys and firmware enrollment: docs/secure-boot.md.
  modules.secureBoot.enable = true;

  networking.hostName = "storm";

  system.stateVersion = "26.05";
}
