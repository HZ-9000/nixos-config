{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (_: {
  firewall = true;
  polkit = true;
  tailscale = true;
  sunshine = false;
  homeSsh = true;
  sopsAgeKey = "/etc/age/keys.txt";
})
