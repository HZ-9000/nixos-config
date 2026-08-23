{
  description = "NixOS configuration of HZ-9000";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    preservation.url = "github:nix-community/preservation";
    disko.url = "github:nix-community/disko/v1.11.0";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      # preservation,
      ...
    }:
    let
      inherit (inputs.nixpkgs) lib;
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

            disko.nixosModules.default
            ../hosts/storm/disko-fs.nix
            ../hosts/storm/hardware-configuration.nix
            ../hosts/storm/preservation.nix
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

            disko.nixosModules.default
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            ../hosts/stormlight/disko-fs.nix
            ../hosts/stormlight/hardware-configuration.nix
            # ../hosts/stormlight/preservation.nix
          ];
        };

        parallels = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = inputs // {
            inherit mylib myvars;
          };

          modules = [
            ./configuration.nix

            # ../modules/base
            # ../modules/nixos/base/i18n.nix
            # ../modules/nixos/base/user-group.nix
            # ../modules/nixos/base/ssh.nix

            # disko.nixosModules.default
            # ../hosts/parallels/disko-fs.nix
            ../hosts/parallels/hardware-configuration.nix
            # ../hosts/parallels/preservation.nix
          ];
        };
      };
    };
}