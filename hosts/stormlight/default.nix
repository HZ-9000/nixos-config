{ ... }:
{
  disabledModules = [
    ../../modules/nixos/base/sops.nix
  ];

  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  networking.hostName = "stormlight";

  system.stateVersion = "26.05";
}
