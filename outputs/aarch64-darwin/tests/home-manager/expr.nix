{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (
  name:
  let
    cfg = outputs.darwinConfigurations.${name}.config;
  in
  # Indexing by primaryUser also asserts it matches the Home Manager user.
  cfg.home-manager.users.${cfg.system.primaryUser}.home.homeDirectory
)
