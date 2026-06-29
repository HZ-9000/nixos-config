{ lib, outputs, system }:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (_: system)
