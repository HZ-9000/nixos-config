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

      ## Python
      python3
      python3Packages.ipython
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      valgrind
    ];

  programs.zed-editor = {
    enable = true;
  };
}
