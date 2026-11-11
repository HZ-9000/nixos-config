{ lib, mylib, ... }:
{
  modules.desktop.fonts.enable = true;
  # Every desktop games today; a host can opt out with `modules.desktop.gaming.enable = false`.
  modules.desktop.gaming.enable = lib.mkDefault true;

  imports = mylib.scanPaths ./.;
}
