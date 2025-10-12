{ ... }:
{
  imports = [
    ./nvim.nix                        # neovim editor
    ./zsh.nix                         # shell
    ./browser.nix
    ./hyprland
    ./waybar
    ./vicinae/vicinae.nix
  ];
}
