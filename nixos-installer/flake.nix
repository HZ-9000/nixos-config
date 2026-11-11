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
    # Keep on the same version as the main flake. Only for the modules.secureBoot option,
    # which hosts/<host> sets; configuration.nix turns it off.
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      mylib = import ../lib { inherit lib; };
      myvars = import ../vars { inherit lib; };

      # The host's own machine settings (hardware, disk, preservation, hostname), so the
      # installed system matches what the main flake builds; only the desktop is left out.
      mkInstaller =
        hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // {
            inherit inputs mylib myvars;
          };
          modules = [
            ./configuration.nix
            ../hosts/${hostName}

            ../modules/base
            ../modules/nixos/base/i18n.nix
            ../modules/nixos/base/nushell.nix
            ../modules/nixos/base/secure-boot.nix
            ../modules/nixos/base/ssh.nix
            ../modules/nixos/base/user-group.nix
          ];
        };
    in
    {
      nixosConfigurations = lib.genAttrs [ "storm" "stormlight" ] mkInstaller;
    };
}
