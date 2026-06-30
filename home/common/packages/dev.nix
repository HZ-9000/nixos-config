{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      ## Lsp
      nixd # nix
      #nil
      ## Editors
      code-cursor

      ## formating
      shfmt
      treefmt
      nixfmt

      ## C / C++
      gcc
      gdb
      #gef
      cmake
      gnumake

      ## Python
      python3
      python312Packages.ipython
    ]
    ++ lib.optionals stdenv.isLinux [
      valgrind
    ];

  programs.zed-editor = {
    enable = true;
  };
}
