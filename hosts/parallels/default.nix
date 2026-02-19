{ pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/home-manager
  ];
}