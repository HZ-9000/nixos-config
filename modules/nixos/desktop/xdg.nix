{ lib, pkgs, ... }:
{
  xdg.terminal-exec = {
    enable = true;
    package = pkgs.xdg-terminal-exec;
    settings =
      let
        my_terminal_desktop = [
          "com.mitchellh.ghostty.desktop"
          "kitty.desktop"
          "foot.desktop"
          "Alacritty.desktop"
        ];
      in
      {
        GNOME = my_terminal_desktop ++ [
          "com.raggesilver.BlackBox.desktop"
          "org.gnome.Terminal.desktop"
        ];
        default = my_terminal_desktop;
      };
  };

  xdg = {
    autostart.enable = lib.mkDefault true;
    menus.enable = lib.mkDefault true;
    mime.enable = lib.mkDefault true;
    icons.enable = lib.mkDefault true;
  };
}
