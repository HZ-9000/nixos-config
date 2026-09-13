{ pkgs, myvars, ... }:
{
  # User account shell — all other user fields (isNormalUser, extraGroups,
  # initialPassword, etc.) are owned by modules/nixos/base/user-group.nix
  users.users.${myvars.username}.shell = pkgs.nushell;

  nix.settings.allowed-users = [ myvars.username ];
}
