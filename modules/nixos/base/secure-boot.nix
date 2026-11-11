{
  pkgs,
  lib,
  config,
  lanzaboote,
  ...
}:
with lib;
let
  cfg = config.modules.secureBoot;
in
{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  options.modules.secureBoot = {
    enable = mkEnableOption "Secure Boot via lanzaboote";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
