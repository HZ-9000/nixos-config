{ ... }:
{
  imports = [
    ./nvim.nix                        # neovim editor
    ./zsh                             # shell
    ./browser.nix
    ./hyprland
    ./packages
    ./waybar
    ./ssh.nix
    ./gtk.nix
    ./nemo.nix
    ./rofi/rofi.nix
    ./xdg-mimes.nix
    ./vicinae/vicinae.nix
    ./waypaper.nix
  ];
}
