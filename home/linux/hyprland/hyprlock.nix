{ inputs, pkgs, ... }:
{
  # hyprlock is enabled at system level via programs.hyprlock.enable
  # This module handles any home-manager level hyprlock configuration
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        disable_loading_bar = false;
      };

      background = [
        {
          monitor = "";
          path = "${../../../wallpapers/framework_dunes.jpeg}";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
    };
  };
}
