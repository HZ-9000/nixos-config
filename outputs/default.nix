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

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };

  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (args // { system = "aarch64-darwin"; });
  };

  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);

  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # Per-node deployment settings from `mylib.colmenaSystem`, keyed by host name.
  colmenaDeployments = lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);
in
{
  # Each colmena node is rebuilt from its nixosConfigurations entry: the same
  # user modules and specialArgs, plus a package set matching lib/nixosSystem.nix.
  colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = builtins.mapAttrs (
          name: _:
          import nixpkgs {
            inherit (nixosConfigurations.${name}.pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          }
        ) colmenaDeployments;
        nodeSpecialArgs = builtins.mapAttrs (
          name: _: nixosConfigurations.${name}._module.specialArgs
        ) colmenaDeployments;
        allowApplyAll = false;
      };
    }
    // builtins.mapAttrs (name: deployment: {
      imports = [
        deployment
        # colmena evaluates with nixpkgs' plain lib, which lacks the flake's
        # version info; without this the toplevel reports `26.05pre-git` and
        # differs from nixosConfigurations.
        {
          system.nixos.versionSuffix = lib.trivial.versionSuffix;
          system.nixos.revision = lib.trivial.revisionWithDefault null;
        }
      ]
      ++ nixosConfigurations.${name}._module.args.modules;
    }) colmenaDeployments
  );

  # NixOS Configurations
  inherit nixosConfigurations;

  # nix-darwin Configurations
  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  # Eval tests for all systems. Each per-arch evalTests must be { } (pass).
  evalTests = lib.lists.all (it: it.evalTests == { }) (builtins.attrValues allSystems);

  # `nix flake check` needs derivations, so wrap each system's eval tests in one.
  checks = forAllSystems (system: {
    eval-tests =
      let
        results = allSystems.${system}.evalTests;
      in
      nixpkgs.legacyPackages.${system}.runCommand "eval-tests" { } (
        if results == { } then
          "touch $out"
        else
          "echo 'eval tests failed:' ${lib.escapeShellArg (builtins.toJSON results)} >&2; exit 1"
      );
  });

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          just
          nixfmt
          nixfmt-tree
          deadnix # unused bindings in *.nix
          statix # lints and suggestions for Nix code
        ];
      };
    }
  );
}
