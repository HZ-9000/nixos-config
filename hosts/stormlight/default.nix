{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./amd-hardware.nix
    ./disko-fs.nix
    ../common/preservation.nix
    ../common/secure-boot.nix
  ];

  modules.desktop.gaming.enable = true;

  boot.blacklistedKernelModules = [ "sp5100_tco" ];
  systemd.settings.Manager.RebootWatchdogSec = "off";
  boot.kernelParams = [ "nowatchdog" ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
