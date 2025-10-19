{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = [
        "Jetbrains monospace"
      ];
      background-opacity = 0.8;
    };
  };

  programs.starship = {
    enable = true;
  };
}
