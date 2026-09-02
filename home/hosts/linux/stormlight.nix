{ ... }:
{
  disabledModules = [
    ../../linux/base/sops.nix
  ];

  imports = [ ../../linux/default.nix ];
}
