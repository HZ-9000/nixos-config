{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Claude Code
    claude-code

    # Opencode
    opencode

    # Remote
    colmena
    devbox

    # Infrastructure
    opentofu

    # Go
    go
    gopls # language server
    gotools # goimports and friends

    # Rust
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer # language server

    # Python
    uv
  ];
}
