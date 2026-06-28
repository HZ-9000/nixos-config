{ inputs, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    ./btop.nix
    ./nvim.nix
    ./ghostty.nix
  ];
}
