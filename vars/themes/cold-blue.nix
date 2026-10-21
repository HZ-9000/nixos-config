# Cold Blue — inspired by the Death Stranding 2 UI: dark blue-black glass,
# off-white text, hologram cyan with chiral gold and BT red accents.
#
# See ./rose-pine-moon.nix for the format.
{
  name = "ColdBlue";
  mode = "dark";

  font = {
    ui = "JetBrains Mono";
    mono = "JetBrainsMono Nerd Font";
    size = 12;
  };

  cursor = {
    name = "Bibata-Modern-Ice";
    package = "bibata-cursors";
    size = 24;
  };

  palette = {
    mPrimary = "#4fc3e8";
    mOnPrimary = "#0b0f14";
    mSecondary = "#d4a64a";
    mOnSecondary = "#0b0f14";
    mTertiary = "#8fb8cc";
    mOnTertiary = "#0b0f14";
    mError = "#d9434f";
    mOnError = "#0b0f14";
    mSurface = "#0b0f14";
    mOnSurface = "#e6edf2";
    mSurfaceVariant = "#131a22";
    mOnSurfaceVariant = "#8a9aa8";
    mOutline = "#2a3a48";
    mShadow = "#05070a";
    mHover = "#1c2a36";
    mOnHover = "#ffffff";
    terminal = {
      background = "#0b0f14";
      foreground = "#e6edf2";
      cursor = "#4fc3e8";
      cursorText = "#0b0f14";
      selectionBg = "#1f3a4d";
      selectionFg = "#e6edf2";
      normal = {
        black = "#131a22";
        red = "#d9434f";
        green = "#6fbf8e";
        yellow = "#d4a64a";
        blue = "#4f9fd8";
        magenta = "#a58bd6";
        cyan = "#4fc3e8";
        white = "#b8c4cc";
      };
      bright = {
        black = "#3a4a58";
        red = "#ef6a72";
        green = "#8fd9a8";
        yellow = "#f0c66a";
        blue = "#7ab8e8";
        magenta = "#c2a8ec";
        cyan = "#8ad8f0";
        white = "#f2f6f8";
      };
    };
  };
}
