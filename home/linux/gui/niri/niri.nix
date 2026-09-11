{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
    nwg-displays
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
    wl-color-picker
    swappy
  ];
}
