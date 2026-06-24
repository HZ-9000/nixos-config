{ pkgs, ... }:
{
  # Base system tools available to all users.
  # - Nix settings (caches, overlays, experimental-features) → modules/base/nix.nix
  # - allowUnfree, GC, auto-optimise → modules/nixos/base/nix.nix
  # - time.timeZone / i18n.defaultLocale → modules/nixos/base/i18n.nix
  # - system.stateVersion → hosts/<name>/default.nix
  environment.systemPackages = with pkgs; [
    git
    gh
    lua
    brightnessctl
  ];

  security.pam.services.hyprlock = {};
}
