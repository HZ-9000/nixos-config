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

      input-field = [
        {
          size = "200, 50";
          outline_thickness = 2;
          inner_color = "rgba(0, 0, 0, 0.5)";
          outer_color = "rgba(40, 40, 40, 1.0)";
          check_color = "rgba(152, 151, 26, 0.8)";
          fail_color = "rgba(204, 36, 29, 0.8)";
          font_color = "rgba(235, 219, 178, 1.0)";
          fade_on_empty = false;
          rounding = 0;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          text = " Enter password ";
          color = "rgba(235, 219, 178, 1.0)";
          font_size = 14;
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
