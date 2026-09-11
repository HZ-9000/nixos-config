{ myvars, ... }:
{
  home = {
    inherit (myvars) username;
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
