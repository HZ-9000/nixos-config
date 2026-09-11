{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
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
