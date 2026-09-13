{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (_: "x86_64-linux")
