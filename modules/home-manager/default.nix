{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

{
  home-manager.users.${username} = {
    imports = [
      ./dotfiles.nix
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "25.05";

    programs.home-manager.enable = true;

    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}