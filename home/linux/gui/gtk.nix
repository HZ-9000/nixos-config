{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Jetbrains Mono";
      size = 12;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
