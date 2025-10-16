{ ... }:
{
  imports = [
    ./nvim.nix                        # neovim editor
    ./zsh                             # shell
    ./browser.nix
    ./hyprland
    ./packages
    ./waybar
    ./gtk.nix
    ./theme.nix
    ./nemo.nix
    ./rofi/rofi.nix
    ./xdg-mimes.nix
    ./vicinae/vicinae.nix
    ./waypaper.nix
  ];
}
