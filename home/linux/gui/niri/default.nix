{
  pkgs,
  config,
  osConfig,
  myvars,
  ...
}:
let
  hostName = osConfig.networking.hostName;
in
{
  assertions = [
    {
      assertion = builtins.pathExists (./conf/monitors + "/${hostName}.kdl");
      message = "niri: no display layout for host '${hostName}', create home/linux/gui/niri/conf/monitors/${hostName}.kdl";
    }
  ];

  home.packages = with pkgs; [
    xwayland-satellite

    slurp
    grim
    satty
  ];

  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/${myvars.configDirectoryName}/home/linux/gui/niri/conf";
    in
    {
      "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
      "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
      "niri/spawn-at-startup.kdl".source = mkSymlink "${confPath}/spawn-at-startup.kdl";
      "niri/key-bindings.kdl".source = mkSymlink "${confPath}/key-bindings.kdl";
      "niri/window-rules.kdl".source = mkSymlink "${confPath}/window-rules.kdl";
      "niri/monitor.kdl".source = mkSymlink "${confPath}/monitors/${hostName}.kdl";
    };

  # The polkit agent (niri-flake-polkit) is provided by niri-flake's NixOS module.

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      # trying to stop a previous niri session
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      # and then we start a new one
      /run/current-system/sw/bin/niri-session
    '';
    executable = true;
  };
}
