{ ... }:
{
  imports = [
    ./btop.nix
    ./nvim.nix # neovim editor
    ./zsh # shell
    ./browser.nix
    ./hyprland
    ./ghostty.nix
    ./packages
    ./waybar
    ./gtk.nix
    ./theme.nix
    ./nemo.nix
    ./swaync/swaync.nix
    ./rofi/rofi.nix
    ./xdg-mimes.nix
    ./waypaper.nix
  ];
}
