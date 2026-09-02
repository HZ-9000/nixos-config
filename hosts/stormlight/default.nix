{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
    ./preservation.nix
    ./secure-boot.nix
  ];

  networking.hostName = "stormlight";

  # Temporarily keep sops-nix available for manual use without running it at boot.
  systemd.services.sops-nix.wantedBy = lib.mkForce [ ];

  system.stateVersion = "26.05";
}
