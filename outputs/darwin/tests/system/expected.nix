{ lib, outputs }:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (_: "aarch64-darwin")
