{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (name: {
  firewall = true;
  hyprland = true;
  networkmanager = true;
  polkit = true;
  tailscale = true;
  uwsm = true;
  sunshine = false;
  homeSsh = true;
})
