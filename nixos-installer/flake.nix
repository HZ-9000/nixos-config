{
  description = "NixOS installer configurations for HZ-9000 hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      mylib = import ../lib { inherit lib; };
      myvars = import ../vars { inherit lib; };
      specialArgs = inputs // {
        inherit mylib myvars;
      };
      baseModules = [
        ./configuration.nix
        ../modules/base
        ../modules/nixos/base/bootloader.nix
        ../modules/nixos/base/i18n.nix
        ../modules/nixos/base/user-group.nix
        ../modules/nixos/base/ssh.nix
      ];
      ephemeralModules = [
        ../modules/nixos/base/btrbk.nix
      ];
      mkInstallerSystem =
        system: modules:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = baseModules ++ modules;
        };
    in
    {
      nixosConfigurations = {
        storm = mkInstallerSystem "x86_64-linux" (
          [
            inputs.disko.nixosModules.default
            ../hosts/storm
          ]
          ++ ephemeralModules
        );

        stormlight = mkInstallerSystem "x86_64-linux" (
          [
            inputs.disko.nixosModules.default
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            ../hosts/stormlight
          ]
          ++ ephemeralModules
        );

        parallels = mkInstallerSystem "aarch64-linux" [
          inputs.disko.nixosModules.default
          ../hosts/parallels
        ];
      };
    };
}
