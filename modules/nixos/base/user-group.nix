{ myvars, ... }:
{
  users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = { };
    podman = { };
    docker = { };
    wireshark = { };
    # for android platform tools's udev rules
    adbusers = { };
    dialout = { };
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
      "wireshark"
      "adbusers" # android debugging
      "libvirtd" # virt-viewer / qemu
    ];
  };

  # root's ssh key are mainly used for remote deployment
  users.users.root = {
    inherit (myvars) initialHashedPassword;
    openssh.authorizedKeys.keys = myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys;
  };
}
