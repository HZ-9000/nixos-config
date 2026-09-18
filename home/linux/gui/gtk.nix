{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    gtk3.extraCss = ''
      @import url("noctalia.css");
      @import url("thunar.css");
    '';
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

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-3.0/thunar.css".text = ''
    window.thunar,
    window.thunar .view,
    window.thunar treeview,
    window.thunar iconview {
      background-color: alpha(@window_bg_color, 0.55);
    }
  '';

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
