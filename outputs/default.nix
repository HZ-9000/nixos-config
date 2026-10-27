{
  nixpkgs,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # specialArgs passed to every NixOS module and home-manager module
  # Note: `inputs // { ... }` spreads each individual flake input as a separate attr.
  # We must explicitly re-add `inputs` itself so modules can use `{ inputs, ... }:`.
  genSpecialArgs =
    _system:
    inputs
    // {
      inherit inputs mylib myvars;
    };

  args = {
    inherit
      inputs
      lib
      mylib
      myvars
      genSpecialArgs
      ;
  };

  k8s = import ./x86_64-linux/src/k8s.nix (args // { system = "x86_64-linux"; });

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };

  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (args // { system = "aarch64-darwin"; });
  };

  allSystemNames = (builtins.attrNames nixosSystems) ++ (builtins.attrNames darwinSystems);
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in
{
  colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = genSpecialArgs "x86_64-linux";
        allowApplyAll = false;
      };
    }
    // lib.mapAttrs (name: node: {
      imports = k8s.modulesFor name node ++ [ inputs.agenix.nixosModules.default ];
      deployment = {
        targetHost = node.address;
        targetUser = "root";
        tags = [ node.role ];
      };
    }) myvars.k8s.nodes
  );

  # NixOS Configurations
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # Minimal first-install systems for the NixOS hosts (see nixos-installer/README.md)
  installerConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.installerConfigurations or { }) nixosSystemValues
  );

  # nix-darwin Configurations
  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  # Eval tests for all systems. Each per-arch evalTests must be { } (pass).
  evalTests =
    (lib.lists.all (it: it.evalTests == { }) nixosSystemValues)
    && (lib.lists.all (it: it.evalTests == { }) darwinSystemValues);

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell { };
    }
  );
}
