{ pkgs, config, catppuccin, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    catppuccin.homeModules.catppuccin
  ];

  environment.systemPackages = with pkgs; [
    pkgs.ghostty
    pkgs.gh
  ];
}
