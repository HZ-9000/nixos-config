# Cyberpunk Red — inspired by Cyberpunk 2077's Arasaka/combat-HUD red: near-
# black glass surfaces, neon crimson and hot-magenta accents, electric cyan
# for contrast. Square borders and heavier transparency come from niri (no
# corner radius) and the existing Ghostty/noctalia opacity settings.
#
# See ./rose-pine-moon.nix for the format.
{
  name = "CyberpunkRed";
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
    mPrimary = "#ff003c";
    mOnPrimary = "#0a0003";
    mSecondary = "#d6006b";
    mOnSecondary = "#0a0003";
    mTertiary = "#8a1c2b";
    mOnTertiary = "#f2d9dc";
    mError = "#ff1a1a";
    mOnError = "#0a0003";
    mSurface = "#0a0506";
    mOnSurface = "#f0e4e6";
    mSurfaceVariant = "#170a0d";
    mOnSurfaceVariant = "#b08088";
    mOutline = "#661a26";
    mShadow = "#000000";
    mHover = "#2b0e14";
    mOnHover = "#ffe8ec";
    terminal = {
      background = "#0a0506";
      foreground = "#f0e4e6";
      cursor = "#ff003c";
      cursorText = "#0a0506";
      selectionBg = "#4d1620";
      selectionFg = "#f0e4e6";
      normal = {
        black = "#170a0d";
        red = "#ff003c";
        green = "#39ff6a";
        yellow = "#ffcc33";
        blue = "#3fa9f5";
        magenta = "#ff2e92";
        cyan = "#00eaff";
        white = "#d9c4c8";
      };
      bright = {
        black = "#3a1820";
        red = "#ff4d6d";
        green = "#7dffa0";
        yellow = "#ffe066";
        blue = "#71c4ff";
        magenta = "#ff6fb0";
        cyan = "#5ff5ff";
        white = "#ffeef0";
      };
    };
  };
}
