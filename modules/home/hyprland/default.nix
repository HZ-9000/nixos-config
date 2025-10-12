{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
