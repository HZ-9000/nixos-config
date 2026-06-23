{ ... }:
{
  imports = [
    ./fonts.nix
    ./hardware.nix
    ./nix.nix
    ./user.nix
    # wayland.nix removed — Hyprland is configured in modules/nixos/desktop/hyprland.nix
    ./xserver.nix
  ];
}
