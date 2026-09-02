{
  config,
  inputs,
  myvars,
  pkgs,
  ...
}:
let
  package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  wallpapers = ../../../../wallpapers;
  configDir = "${config.home.homeDirectory}/${myvars.configDirectoryName}/home/linux/gui/noctalia/config";
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

  # Live-editable config under the repository checkout.
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink configDir;
}
