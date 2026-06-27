{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (
  name: outputs.nixosConfigurations.${name}.config.nixpkgs.hostPlatform.system
)
