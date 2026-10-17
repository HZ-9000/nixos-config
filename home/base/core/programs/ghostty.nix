{ pkgs, myvars, ... }:
let
  inherit (myvars) theme;
  term = theme.palette.terminal;
  ansi = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
  ];
in
{
  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      font-family = [ theme.font.mono ];
      theme = theme.name;
      background-opacity = 0.55;
      background-opacity-cells = true;
      window-decoration = false;
      gtk-titlebar = false;
    };

    # Generated from the flake theme (vars/themes) rather than a built-in name.
    themes.${theme.name} = {
      background = term.background;
      foreground = term.foreground;
      cursor-color = term.cursor;
      cursor-text = term.cursorText;
      selection-background = term.selectionBg;
      selection-foreground = term.selectionFg;
      palette =
        pkgs.lib.imap0 (i: c: "${toString i}=${term.normal.${c}}") ansi
        ++ pkgs.lib.imap0 (i: c: "${toString (i + 8)}=${term.bright.${c}}") ansi;
    };
  };
}
