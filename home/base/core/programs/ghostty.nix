{ pkgs, ... }:
{
  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      font-family = [
        "JetBrainsMono Nerd Font"
      ];
      background-opacity = 0.1;
    };
  };
}
