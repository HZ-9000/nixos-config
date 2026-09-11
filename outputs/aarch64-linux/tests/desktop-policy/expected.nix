{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (name: {
  firewall = true;
  networkmanager = true;
  polkit = true;
  tailscale = true;
  sunshine = false;
  homeSsh = true;
  sopsAgeKey = "/etc/age/keys.txt";
})
