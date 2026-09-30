{
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}:
let
  hostVars = myvars // {
    username = "hz-9000";
  };
in
{
  darwinConfigurations.tempest = mylib.macosSystem {
    inherit
      inputs
      lib
      system
      genSpecialArgs
      ;
    myvars = hostVars;
    specialArgs = (genSpecialArgs system) // {
      myvars = hostVars;
    };
    darwin-modules = map mylib.relativeToRoot [
      "hosts/tempest"
      "modules/darwin"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/darwin/tempest.nix"
    ];
  };
}
