{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    ./btop.nix
    ./nvim.nix
    ./ghostty.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
