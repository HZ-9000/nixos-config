{ inputs, config, pkgs, ... }:
let
  package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  wallpapers = ../../../wallpapers;
  configDir = "${config.home.homeDirectory}/nix-config/home/linux/noctalia/config";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file."Pictures/wallpapers".source = wallpapers;

  home.packages = [
    pkgs.app2unit
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    inherit package;
    validateConfig = false;
  };

  # Live-editable config under the repo checkout (e.g. ~/nix-config).
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink configDir;
}
