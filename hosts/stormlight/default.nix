{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  modules.desktop.gaming.enable = true;

  # The onboard AMD sp5100_tco watchdog can't be disabled (BIOS lock bit), so on
  # shutdown/reboot the kernel hangs waiting for it to stop ("watchdog0: watchdog
  # did not stop!" + "task shutdown:1 blocked" repeating forever). Disabling the
  # watchdog subsystem entirely avoids the kernel ever touching it.
  boot.kernelParams = [ "nowatchdog" ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
