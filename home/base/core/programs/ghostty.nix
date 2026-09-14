{ pkgs, ... }:
{
  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      font-family = [
        "JetBrainsMono Nerd Font"
      ];
      theme = "Rosé Pine Moon";
      background-opacity = 0.55;
      background-opacity-cells = true;
      window-decoration = false;
      gtk-titlebar = false;
    };
  };
}
