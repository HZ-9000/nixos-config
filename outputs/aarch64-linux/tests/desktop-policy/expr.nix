{
  lib,
  myvars,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (
  name:
  let
    config = outputs.nixosConfigurations.${name}.config;
    home = config.home-manager.users.${myvars.username};
  in
  {
    firewall = config.networking.firewall.enable;
    polkit = config.security.polkit.enable;
    tailscale = config.services.tailscale.enable;
    sunshine = config.services.sunshine.enable;
    homeSsh = home.programs.ssh.enable;
    sopsAgeKey = home.sops.age.keyFile;
  }
)
