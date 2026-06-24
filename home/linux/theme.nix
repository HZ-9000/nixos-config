{ inputs, lib, ... }:
{
  # https://github.com/catppuccin/nix
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    # Default enable for all supported programs
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "green";

    # Disabled per-program overrides
    starship.enable = false; # custom starship.toml via dotfiles

    # Hyprland has its own colour scheme in home/linux/hyprland/config.nix
    # (Gruvbox green/red borders). Catppuccin's Hyprland integration writes
    # ~/.config/hypr/themes/catppuccin.lua which conflicts with home-manager's
    # own management of that directory.
    hyprland.enable = lib.mkForce false;
  };
}
