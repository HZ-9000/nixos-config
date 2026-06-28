{ ... }:
{
  # Parallels VM — import base Linux config. Adjust as needed for VM limitations.
  imports = [ ../../linux/default.nix ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
