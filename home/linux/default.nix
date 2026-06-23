{ ... }:
{
  imports = [
    ./browser.nix
    ./gtk.nix
    ./theme.nix
    ./nemo.nix
    ./xdg-mimes.nix
    ./waypaper.nix
    ./dotfiles.nix
    ./hyprland
    ./packages
    ./waybar
    ./swaync/swaync.nix
    ./rofi/rofi.nix
    ./zsh
  ];
}
