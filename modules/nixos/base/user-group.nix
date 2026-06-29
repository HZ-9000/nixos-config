{ myvars, ... }:
{
  users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = { };
    podman = { };
    docker = { };
  };

  users.users."${myvars.username}" = {
    initialHashedPassword = myvars.initialHashedPassword;
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
    initialHashedPassword = myvars.initialHashedPassword;
  };
}
