{ lib, desktopHosts }:
lib.genAttrs desktopHosts (_: {
  firewall = true;
  networkmanager = true;
  polkit = true;
  tailscale = true;
  sunshine = false;
  homeSsh = true;
})
