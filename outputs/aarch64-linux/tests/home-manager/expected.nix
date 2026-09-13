{
  lib,
  myvars,
  outputs,
}:
let
  inherit (myvars) username;
  hosts = builtins.attrNames outputs.nixosConfigurations;
in
lib.genAttrs hosts (_: "/home/${username}")
