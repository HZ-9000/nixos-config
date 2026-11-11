# Machine-level settings only (hardware, disk, preservation). The installer flake imports
# this file too, so desktop policy belongs in modules/nixos/desktop.nix.
{ disko, nixos-hardware, ... }:
{
  imports = [
    disko.nixosModules.disko
    nixos-hardware.nixosModules.framework-amd-ai-300-series
    ./hardware-configuration.nix
    ./amd-hardware.nix
    ./disko-fs.nix
    ../common/preservation.nix
  ];

  boot.blacklistedKernelModules = [ "sp5100_tco" ];
  systemd.settings.Manager.RebootWatchdogSec = "off";
  boot.kernelParams = [ "nowatchdog" ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
