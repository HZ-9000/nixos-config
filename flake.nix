{
  inputs = {
    # Use the Nixpkgs version that matches your system.stateVersion
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = 
    inputs@{ self, nixpkgs, nixos-hardware, ... }:
    let
      username = "delta";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
	config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  nixos-hardware.nixosModules.framework-amd-ai-300-series
          # Import your existing configuration.nix
	  ./configuration.nix
          ./hosts/stormlight
        ];
	specialArgs = {
          inherit self inputs username;
	};
      };
    };
  };
}
