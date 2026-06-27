{ ... }:
{
  # Parallels VM — import base Linux config but skip Hyprland-specific stuff
  # that may not work well in a VM. Adjust as needed.
  imports = [ ../../linux/default.nix ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
