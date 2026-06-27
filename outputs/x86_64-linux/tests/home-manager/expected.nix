{ lib, myvars, outputs }:
let
  username = myvars.username;
  hosts = builtins.attrNames outputs.nixosConfigurations;
in
lib.genAttrs hosts (_: "/home/${username}")
