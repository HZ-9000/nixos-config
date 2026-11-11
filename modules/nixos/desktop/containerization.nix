{ ... }:
{
  # User membership (docker group) is set in modules/nixos/base/user-group.nix.
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
}
