{
  lib,
  myvars,
  desktopHosts,
  outputs,
}:
let
  inherit (myvars) username;
  hosts = desktopHosts;
in
lib.genAttrs hosts (
  name: outputs.nixosConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
)
