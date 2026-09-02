{ myvars, ... }:
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
        inherit (myvars) initialHashedPassword;
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
        inherit (myvars) initialHashedPassword;
        openssh.authorizedKeys.keys = myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys;
      };
    };
  };
}
