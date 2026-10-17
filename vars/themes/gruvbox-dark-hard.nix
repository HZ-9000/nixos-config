# Gruvbox Dark Hard — https://github.com/morhetz/gruvbox
#
# See ./rose-pine-moon.nix for the format.
{
  name = "GruvboxDarkHard";
  mode = "dark";

  font = {
    ui = "JetBrains Mono";
    mono = "JetBrainsMono Nerd Font";
    size = 12;
  };

  cursor = {
    name = "Bibata-Modern-Ice";
    package = "bibata-cursors"; # attribute name in nixpkgs
    size = 24;
  };

  palette = {
    mPrimary = "#fabd2f"; # yellow
    mOnPrimary = "#1d2021";
    mSecondary = "#83a598"; # blue
    mOnSecondary = "#1d2021";
    mTertiary = "#8ec07c"; # aqua
    mOnTertiary = "#1d2021";
    mError = "#fb4934"; # red
    mOnError = "#1d2021";
    mSurface = "#1d2021"; # bg0_h
    mOnSurface = "#ebdbb2"; # fg1
    mSurfaceVariant = "#282828"; # bg0
    mOnSurfaceVariant = "#a89984"; # fg4
    mOutline = "#665c54"; # bg3
    mShadow = "#000000";
    mHover = "#3c3836"; # bg1
    mOnHover = "#ebdbb2";
    terminal = {
      background = "#1d2021";
      foreground = "#ebdbb2";
      cursor = "#ebdbb2";
      cursorText = "#1d2021";
      selectionBg = "#504945"; # bg2
      selectionFg = "#ebdbb2";
      normal = {
        black = "#1d2021";
        red = "#cc241d";
        green = "#98971a";
        yellow = "#d79921";
        blue = "#458588";
        magenta = "#b16286";
        cyan = "#689d6a";
        white = "#a89984";
      };
      bright = {
        black = "#928374";
        red = "#fb4934";
        green = "#b8bb26";
        yellow = "#fabd2f";
        blue = "#83a598";
        magenta = "#d3869b";
        cyan = "#8ec07c";
        white = "#ebdbb2";
      };
    };
  };
}
