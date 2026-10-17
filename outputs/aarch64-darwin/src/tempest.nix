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
  darwinConfigurations.tempest = mylib.macosSystem {
    inherit
      inputs
      lib
      system
      genSpecialArgs
      myvars
      ;
    darwin-modules = map mylib.relativeToRoot [
      "hosts/tempest"
      "modules/darwin"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/darwin/tempest.nix"
    ];
  };
}
