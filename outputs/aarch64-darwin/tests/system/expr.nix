{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (
  name: outputs.darwinConfigurations.${name}.pkgs.stdenv.hostPlatform.system
)
