{ inputs, lib, ... }@args:
let
  inherit (inputs) haumea;

  tempest = import ./src/tempest.nix args;

  outputs = {
    darwinConfigurations = tempest.darwinConfigurations or { };
  };
in
outputs
// {
  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // {
      inherit outputs;
    };
  };
}
