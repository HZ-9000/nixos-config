{ mylib, ... }:
{
  # Only packages.nix is pulled from modules/base: hardware.nix is NixOS-only,
  # and nix.nix / user.nix are superseded by the darwin versions here.
  imports = mylib.scanPaths ./. ++ [ ../base/packages.nix ];
}
