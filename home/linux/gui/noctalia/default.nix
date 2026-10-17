{
  lib,
  inputs,
  myvars,
  pkgs,
  ...
}:
let
  wallpapers = ../../../../wallpapers;
  inherit (myvars) theme;
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

    # config.toml holds everything except theme-dependent values, which come
    # from the flake theme (vars/themes). The result is validated at build
    # time; edits need a rebuild (runtime tweaks via noctalia's settings menu
    # still work).
    settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile ./config/config.toml)) {
      shell.font_family = theme.font.ui;
      bar.main.font_family = theme.font.ui;
      theme = {
        inherit (theme) mode;
        source = "custom";
        custom_palette = theme.name;
      };
      widget.session.color = theme.palette.mOnSurface;
    };

    customPalettes.${theme.name}.${theme.mode} = theme.palette;
  };
}
