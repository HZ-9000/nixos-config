{
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
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
