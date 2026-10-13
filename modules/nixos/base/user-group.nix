{ myvars, config, ... }:
{
  users = {
    mutableUsers = false;

    groups = {
      "${myvars.username}" = { };
      podman = { };
      docker = { };
      wireshark = { };
      adbusers = { };
      dialout = { };
    };

    users = {
      "${myvars.username}" = {
        hashedPasswordFile = config.age.secrets.user-password.path;
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
          "adbusers"
          "libvirtd"
        ];
      };

      root = {
        hashedPasswordFile = config.age.secrets.root-password.path;
        openssh.authorizedKeys.keys = myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys;
      };
    };
  };
}
