{
  lib,
  myvars,
  outputs,
}:
let
  inherit (myvars) username;
  hosts = builtins.attrNames outputs.darwinConfigurations;
in
lib.genAttrs hosts (_: "/Users/${username}")
