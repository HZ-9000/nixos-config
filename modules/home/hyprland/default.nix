{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
