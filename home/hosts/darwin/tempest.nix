{ myvars, ... }:
{
  imports = [ ../../darwin/default.nix ];

  home.homeDirectory = "/Users/${myvars.username}";
}
