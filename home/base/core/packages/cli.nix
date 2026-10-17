{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Tools / useful cli
    hyperfine # benchmarking tool
    pastel # cli to manipulate colors

    ## Monitoring
    htop

    ## Utilities
    jq # JSON processor
    unzip
    tmux
  ];
}
