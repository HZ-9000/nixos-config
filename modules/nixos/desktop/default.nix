{ mylib, ... }:
{
  modules.desktop.fonts.enable = true;

  imports = mylib.scanPaths ./.;
}
