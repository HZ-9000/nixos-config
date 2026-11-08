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

    # Python
    uv
  ];
}
