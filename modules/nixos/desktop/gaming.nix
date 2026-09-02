{
  pkgs,
  pkgs-x64,
  nix-gaming,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.gaming;
in
{
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
  ];

  options.modules.desktop = {
    gaming = {
      enable = mkEnableOption "Install Game Suite";
    };
  };

  config = mkIf cfg.enable {
    # ==========================================================================
    # Gaming on Linux
    #
    #   <https://www.protondb.com/> can give you an idea what works where and how.
    #   Begineer Guide: <https://www.reddit.com/r/linux_gaming/wiki/faq/>
    # ==========================================================================

    # Games installed by Steam works fine on NixOS, no other configuration needed.
    # https://github.com/NixOS/nixpkgs/blob/master/doc/packages/steam.section.md
    programs = {
      steam = {
        enable = true;
        package = pkgs-x64.steam;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extest.enable = true;
        fontPackages = [];
        platformOptimizations.enable = true;
      };

      # Optimise Linux system performance on demand.
      gamemode.enable = true;
    };

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    services.pipewire.lowLatency.enable = true;
  };
}
