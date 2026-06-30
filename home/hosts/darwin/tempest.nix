{ myvars, ... }:
{
  imports = [ ../../darwin/default.nix ];

  home.stateVersion = "26.05";
  home.homeDirectory = "/Users/${myvars.username}";

  programs.home-manager.enable = true;
}
