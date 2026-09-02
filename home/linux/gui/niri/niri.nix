{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
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
