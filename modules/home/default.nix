{ ... }:
{
  imports = [
    ./nvim.nix                        # neovim editor
    ./zsh.nix                         # shell
    ./browser.nix
    ./hyprland
    ./waybar
    ./ssh.nix
    ./vicinae/vicinae.nix
  ];
}
