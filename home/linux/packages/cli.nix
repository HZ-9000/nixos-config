{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Better core utils
    ripgrep # grep replacement

    ## Tools / useful cli
    hyperfine # benchmarking tool
    pastel # cli to manipulate colors

    ## Monitoring
    htop

    ## Utilities
    jq # JSON processor
    openssl
    pamixer # pulseaudio command line mixer
    poweralertd
    unzip
    wget
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    xdg-utils
    tmux
  ];
}
