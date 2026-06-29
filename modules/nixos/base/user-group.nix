{ config, myvars, ... }:
{
  users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = { };
    podman = { };
    docker = { };
  };

  users.users."${myvars.username}" = {
    passwordFile = config.sops.secrets.user-password.path;
    home = "/home/${myvars.username}";
    isNormalUser = true;
    extraGroups = [
      myvars.username
      "users"
      "wheel"
      "networkmanager"
      "podman"
      "docker"
    ];
  };

  users.users.root = {
    passwordFile = config.sops.secrets.root-password.path;
  };
}
