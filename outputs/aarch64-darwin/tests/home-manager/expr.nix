{
  lib,
  myvars,
  outputs,
}:
let
  inherit (myvars) username;
  hosts = builtins.attrNames outputs.darwinConfigurations;
in
lib.genAttrs hosts (
  name: outputs.darwinConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
)
