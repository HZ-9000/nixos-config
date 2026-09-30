{ myvars, ... }:
{
  networking.hostName = "tempest";

  # Required by nix-darwin options that used to apply to whoever ran
  # darwin-rebuild (system.defaults, homebrew, system.keyboard, ...).
  system.primaryUser = myvars.username;

  system.stateVersion = 7;
}
