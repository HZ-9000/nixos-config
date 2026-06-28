{ ... }:
{
  imports = [
    ./niri.nix
    ./config.nix
    ./variables.nix
    ../hyprland/btop.nix
    ../hyprland/nvim.nix
    ../hyprland/ghostty.nix
  ];
}
