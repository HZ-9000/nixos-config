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
  };

  outputs =
    inputs@{ 
      nixpkgs,
      disko,
      preservation,
      nixos-hardware,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      mylib = import ../lib { inherit lib; };
      myvars = import ../vars { inherit lib; };
    in
    {
      nixosConfigurations = {
        storm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // {
            inherit mylib myvars;
          };

          modules = [
            { networking.hostName = "storm"; }

            ./configuration.nix

            ../modules/base
            ../modules/nixos/base/i18n.nix
            ../modules/nixos/base/user-group.nix
            ../modules/nixos/base/ssh.nix

            inputs.disko.nixosModules.default
            ../hosts/storm/disko-fs.nix
            ../hosts/storm/hardware-configuration.nix
          ];
        };

        stormlight = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // {
            inherit mylib myvars;
          };

          modules = [
            { networking.hostName = "stormlight"; }

            ./configuration.nix

            ../modules/base
            ../modules/nixos/base/i18n.nix
            ../modules/nixos/base/user-group.nix
            ../modules/nixos/base/ssh.nix

            inputs.disko.nixosModules.default
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            ../hosts/stormlight/disko-fs.nix
            ../hosts/stormlight/hardware-configuration.nix
            ../hosts/stormlight/preservation.nix
          ];
        };
      };
    };
}
