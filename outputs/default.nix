{
  self,
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
    system:
    inputs
    // {
      inherit inputs mylib myvars;
      # pass username for backwards compat with existing modules
      username = myvars.username;
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
    aarch64-linux = import ./aarch64-linux (args // { system = "aarch64-linux"; });
  };

  allSystemNames = builtins.attrNames nixosSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in
{
  # NixOS Configurations
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # Formatter for nix files
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
}
