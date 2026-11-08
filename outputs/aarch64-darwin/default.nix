{ lib, inputs, ... }@args:
let
  inherit (inputs) haumea;

  # Every file in ./src returns { darwinConfigurations? }.
  data = haumea.lib.load {
    src = ./src;
    inputs = args;
  };

  outputs = {
    darwinConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.darwinConfigurations or { }) (builtins.attrValues data)
    );
  };
in
outputs
// {
  inherit data; # for debugging

  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // {
      inherit outputs;
    };
  };
}
