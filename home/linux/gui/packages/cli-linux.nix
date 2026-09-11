{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pamixer # pulseaudio command line mixer
    poweralertd
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    xdg-utils
  ];
}
