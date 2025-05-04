{
  lib,
}: let
  username = "hz-9000";
  hosts = [
    "vm-aarch64-prl"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")
