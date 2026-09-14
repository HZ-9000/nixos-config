{ inputs, ... }@args:
let
  inherit (inputs) haumea;

  storm = import ./src/storm.nix args;
  stormlight = import ./src/stormlight.nix args;

  outputs = {
    nixosConfigurations = (storm.nixosConfigurations or { }) // (stormlight.nixosConfigurations or { });
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
