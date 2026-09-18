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
    window.thunar {
      background-color: alpha(@window_bg_color, 0.68);
      color: @window_fg_color;
    }

    window.thunar .view,
    window.thunar treeview,
    window.thunar iconview,
    window.thunar viewport,
    window.thunar .sidebar {
      background-color: transparent;
      color: @view_fg_color;
    }

    window.thunar toolbar,
    window.thunar .toolbar {
      background-color: transparent;
      color: @headerbar_fg_color;
      border-color: transparent;
      box-shadow: none;
    }

    window.thunar headerbar {
      min-height: 0;
      padding: 0;
      margin: 0;
      border: 0;
      background: transparent;
      box-shadow: none;
    }

    window.thunar entry,
    window.thunar entry.search {
      background-color: alpha(@window_bg_color, 0.38);
      color: @window_fg_color;
      border-color: alpha(@accent_color, 0.35);
      box-shadow: none;
    }

    window.thunar entry:focus,
    window.thunar entry.search:focus {
      background-color: alpha(@window_bg_color, 0.48);
      border-color: alpha(@accent_color, 0.7);
    }

    window.thunar .view:selected,
    window.thunar treeview:selected,
    window.thunar iconview:selected {
      background-color: alpha(@accent_bg_color, 0.78);
      color: @accent_fg_color;
    }

    window.thunar image {
      -gtk-icon-effect: none;
      opacity: 1;
    }
  '';

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
