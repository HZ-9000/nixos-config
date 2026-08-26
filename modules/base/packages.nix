{ pkgs, ... }:
{
  # Default editor: Helix (`hx`). Privileged edits (`sudoedit`, …) prefer `nvim --clean`
  # via `SUDO_EDITOR`; invoke `nvim --clean` manually for other sensitive workflows.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "nvim --clean";
  };

  environment.systemPackages = with pkgs; [
    # core tools
    nushell # nushell
    fastfetch
    helix # default $EDITOR (`hx`)
    neovim # backup editor; `nvim --clean` for sensitive / privileged edits (`$SUDO_EDITOR`)
    gnumake # Makefile
    just # a command runner like gnumake, but simpler
    git # used by nix flakes

    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # search for files by its content, replacement of grep
    (ripgrep.override { withPCRE2 = true; })

    # networking tools
    wget
    curl

    # file transfer
    rsync

    # security
    libargon2
    openssl

    # misc
    which
    tree
  ];
}