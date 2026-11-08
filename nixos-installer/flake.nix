{
  description = "Minimal first-install NixOS systems for storm and stormlight";

  inputs = {
    # Keep on the same release as the main flake.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, disko, ... }:
    let
      inherit (nixpkgs) lib;
      mylib = import ../lib { inherit lib; };
      myvars = import ../vars { inherit lib; };

      mkInstaller =
        hostName: extraModules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // {
            inherit inputs mylib myvars;
          };
          modules = [
            { networking.hostName = hostName; }

            ./configuration.nix

            ../modules/base
            ../modules/nixos/base/i18n.nix
            ../modules/nixos/base/user-group.nix
            ../modules/nixos/base/ssh.nix

            disko.nixosModules.default
            ../hosts/${hostName}/disko-fs.nix
            ../hosts/${hostName}/hardware-configuration.nix
            ../hosts/${hostName}/amd-hardware.nix
            ../hosts/common/preservation.nix
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        storm = mkInstaller "storm" [ ];
        stormlight = mkInstaller "stormlight" [
          inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        ];
      };
    };
}
