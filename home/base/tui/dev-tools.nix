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
    opencode-desktop

    # Remote
    colmena
    devbox

    # Python
    uv
  ];
}
