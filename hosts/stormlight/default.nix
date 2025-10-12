{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    pkgs.ghostty
    pkgs.gh
  ];
}
