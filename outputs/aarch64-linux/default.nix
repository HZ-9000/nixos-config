{ lib, ... }@args:
let
  parallels = import ./src/parallels.nix args;
in
{
  nixosConfigurations = parallels.nixosConfigurations or { };
}
