{
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      # background = [
      #   {
      #     monitor = "";
      #     path = "${../../../wallpapers/forest_road.jpg}";
      #     blur_passes = 2;
      #     contrast = 0.8916;
      #     brightness = 0.8172;
      #     vibrancy = 0.1696;
      #     vibrancy_darkness = 0.0;
      #   }
      # ];
    };
  };
}
