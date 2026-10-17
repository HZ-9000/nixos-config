# Osaka Jade — noctalia's community palette
# (https://api.noctalia.dev/palette/Osaka%20jade)
#
# See ./rose-pine-moon.nix for the format.
{
  name = "OsakaJade";
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
    mPrimary = "#1a7f67";
    mOnPrimary = "#c0cecb";
    mSecondary = "#167a63";
    mOnSecondary = "#b8c8c4";
    mTertiary = "#166050";
    mOnTertiary = "#ced9d6";
    mError = "#933636";
    mOnError = "#b8c8c4";
    mSurface = "#081512";
    mOnSurface = "#a6b5b1";
    mSurfaceVariant = "#0f251f";
    mOnSurfaceVariant = "#99a8a4";
    mOutline = "#1b6352";
    mShadow = "#040a09";
    mHover = "#1f8972";
    mOnHover = "#eef2f1";
    terminal = {
      background = "#141b1e";
      foreground = "#dadada";
      cursor = "#dadada";
      cursorText = "#141b1e";
      # Upstream uses the background colour here, which makes selections
      # invisible; use normal black instead.
      selectionBg = "#232a2d";
      selectionFg = "#dadada";
      normal = {
        black = "#232a2d";
        red = "#e57474";
        green = "#8ccf7e";
        yellow = "#e5c76b";
        blue = "#67b0e8";
        magenta = "#c47fd5";
        cyan = "#6cbfbf";
        white = "#b3b9b8";
      };
      bright = {
        black = "#464e50";
        red = "#ef7e7e";
        green = "#96d988";
        yellow = "#f4d67a";
        blue = "#71baf2";
        magenta = "#ce89df";
        cyan = "#67cbe7";
        white = "#bdc3c2";
      };
    };
  };
}
