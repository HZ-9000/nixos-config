{ pkgs, ... }:
{
  home.packages = with pkgs; [ waypaper ];

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    folder = ~/Pictures/wallpapers
    monitors = All
    wallpaper = ~/Pictures/wallpapers/framework_dunes.jpeg
  '';
}
