{ inputs, lib, ... }@args:
let
  inherit (inputs) haumea;

  parallels = import ./src/parallels.nix args;

  outputs = {
    nixosConfigurations = parallels.nixosConfigurations or { };
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
