{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pamixer # pulseaudio command line mixer
    playerctl # media keys (MPRIS)
    poweralertd
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    xdg-utils
  ];
}
