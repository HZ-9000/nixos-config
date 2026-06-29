{ lib, myvars, outputs }:
let
  username = myvars.username;
  hosts = builtins.attrNames outputs.darwinConfigurations;
in
lib.genAttrs hosts (_: "/Users/${username}")
