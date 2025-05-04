{
  lib,
  outputs,
}: let
  username = "hz-9000";
  hosts = [
    "vm-aarch64-prl"
  ];
in
  lib.genAttrs
  hosts
  (
    name: outputs.nixosConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
  )
