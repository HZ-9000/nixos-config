{ ... }:
{
  imports = [
    ./nvim.nix                        # neovim editor
    ./zsh.nix                         # shell
    ./browser.nix
    ./hyprland
    ./waybar
    ./ssh.nix
    ./gtk.nix
    ./nemo.nix
    ./xdg-mimes.nix
    ./vicinae/vicinae.nix
  ];
}
