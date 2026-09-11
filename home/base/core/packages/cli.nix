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
    unzip
    tmux
  ];
}
