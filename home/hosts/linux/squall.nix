{ config, ... }:
{
  imports = [ ../../linux/default.nix ];

  home.username = "delta";
  home.homeDirectory = "/home/delta";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
