{
  lib,
  myvars,
  desktopHosts,
}:
let
  inherit (myvars) username;
  hosts = desktopHosts;
in
lib.genAttrs hosts (_: "/home/${username}")
