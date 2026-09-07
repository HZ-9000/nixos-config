{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (name: {
  firewall = true;
  polkit = true;
  tailscale = true;
  sunshine = false;
  homeSsh = true;
  sopsAgeKey = if name == "stormlight" then null else "/etc/age/keys.txt";
})
