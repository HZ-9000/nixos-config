{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyplock.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
