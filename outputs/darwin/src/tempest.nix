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
  darwinConfigurations.tempest = mylib.darwinSystem {
    inherit inputs lib system genSpecialArgs myvars;
    darwin-modules = map mylib.relativeToRoot [
      "hosts/darwin/tempest"
      "modules/darwin/base"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/darwin/tempest.nix"
    ];
  };
}
