{ pkgs, ... }:
{
  # Base system tools available to all users.
  # - Nix settings (caches and experimental features) → modules/base/nix.nix
  # - allowUnfree → lib/nixosSystem.nix; GC, auto-optimise → modules/nixos/base/nix.nix
  # - time.timeZone / i18n.defaultLocale → modules/nixos/base/i18n.nix
  # - system.stateVersion → hosts/<name>/default.nix
  # - git → modules/base/packages.nix; gh → home/base/core/git.nix
  environment.systemPackages = with pkgs; [
    lua
    brightnessctl
  ];
}
