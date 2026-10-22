{ inputs, ... }@args:
let
  inherit (inputs) haumea;

  storm = import ./src/storm.nix args;
  stormlight = import ./src/stormlight.nix args;
  k8s = import ./src/k8s.nix args;

  desktopConfigurations =
    (storm.nixosConfigurations or { }) // (stormlight.nixosConfigurations or { });

  outputs = {
    nixosConfigurations = desktopConfigurations // k8s.nixosConfigurations;
    installerConfigurations = import ./installer.nix args;
  };
in
outputs
// {
  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // {
      inherit outputs;
      # Host groups, so tests can scope desktop-only / k8s-only expectations.
      desktopHosts = builtins.attrNames desktopConfigurations;
      k8sHosts = builtins.attrNames k8s.nixosConfigurations;
    };
  };
}
