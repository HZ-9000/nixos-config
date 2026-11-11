# Desktop hosts: machine settings from hosts/<name>, everything else shared.
{
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}:
{
  nixosConfigurations = lib.genAttrs [ "storm" "stormlight" ] (
    name:
    mylib.nixosSystem {
      inherit
        inputs
        lib
        system
        genSpecialArgs
        myvars
        ;
      nixos-modules = map mylib.relativeToRoot [
        "hosts/${name}"
        "modules/nixos/desktop.nix"
        "secrets/nixos.nix"
      ];
      home-modules = map mylib.relativeToRoot [ "home/linux" ];
    }
  );
}
