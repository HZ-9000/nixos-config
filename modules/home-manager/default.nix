{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    inputs.stylix.homeModules.stylix
    ./dotfiles.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
}