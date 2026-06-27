{ inputs, lib, ... }@args:
let
  inherit (inputs) haumea;

  storm = import ./src/storm.nix args;
  stormlight = import ./src/stormlight.nix args;
  squall = import ./src/squall.nix args;

  outputs = {
    nixosConfigurations =
      (storm.nixosConfigurations or { })
      // (stormlight.nixosConfigurations or { })
      // (squall.nixosConfigurations or { });
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
