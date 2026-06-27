{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (_: "aarch64-linux")
