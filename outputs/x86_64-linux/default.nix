{ lib, inputs, ... }@args:
let
  inherit (inputs) haumea;

  # Every file in ./src returns { nixosConfigurations?, colmena? }.
  data = haumea.lib.load {
    src = ./src;
    inputs = args;
  };
  dataWithoutPaths = builtins.attrValues data;

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) dataWithoutPaths
    );
    colmena = lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) dataWithoutPaths);
  };

  k8sHosts = builtins.attrNames data.k8s.nixosConfigurations;
in
outputs
// {
  inherit data; # for debugging

  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // {
      inherit outputs k8sHosts;
      # Host groups, so tests can scope desktop-only / k8s-only expectations.
      desktopHosts = builtins.attrNames (removeAttrs outputs.nixosConfigurations k8sHosts);
    };
  };
}
