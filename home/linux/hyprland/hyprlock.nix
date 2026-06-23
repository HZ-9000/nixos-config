{ ... }:
{
  # hyprlock is enabled at system level via programs.hyprlock.enable
  # This module handles any home-manager level hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
    };
  };
}
