{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (_: "tempest")
