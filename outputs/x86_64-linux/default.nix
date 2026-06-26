{ lib, ... }@args:
let
  storm = import ./src/storm.nix args;
  stormlight = import ./src/stormlight.nix args;
  squall = import ./src/squall.nix args;
in
{
  nixosConfigurations =
    (storm.nixosConfigurations or { })
    // (stormlight.nixosConfigurations or { })
    // (squall.nixosConfigurations or { });
}
