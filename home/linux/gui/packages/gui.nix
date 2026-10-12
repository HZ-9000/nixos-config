{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    audacity
    gimp
    obs-studio
    mpv # audio / video
    imv # images

    ## Documents (default handlers in xdg-mimes.nix)
    gnome-text-editor
    evince # pdf
    libreoffice
    file-roller # archives

    ## Chat
    webcord

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity
    wl-color-picker # Mod+C
    woomer # Mod+equal, screen zoom
  ];
}
