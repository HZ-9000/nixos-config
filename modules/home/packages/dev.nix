{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Lsp
    nixd # nix

    ## Editors
    code-cursor

    ## formating
    #shfmt
    #treefmt
    #nixfmt-rfc-style

    ## C / C++
    gcc
    gdb
    #gef
    cmake
    #gnumake
    #valgrind
    #llvmPackages_20.clang-tools

    ## Python
    #python3
    #python312Packages.ipython
  ];

  programs.zed-editor = {
    enable = true;
  };
}
