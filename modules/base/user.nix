{ pkgs, myvars, ... }:
{
  # User account creation
  # Note: home-manager integration is handled by lib/nixosSystem.nix
  users.users.${myvars.username} = {
    isNormalUser = true;
    description = myvars.username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    initialPassword = "root";
  };

  nix.settings.allowed-users = [ myvars.username ];
}
