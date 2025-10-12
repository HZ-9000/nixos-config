{
  inputs = {
    # Use the Nixpkgs version that matches your system.stateVersion
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = 
    inputs@{ 
      self, 
      nixpkgs,
      nixos-hardware,
      ... 
  }: 
  {
    # Replace 'nixos' with your actual system's hostname
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Or "aarch64-linux" for ARM
        modules = [
	  nixos-hardware.nixosModules.framework-amd-ai-300-series
          # Import your existing configuration.nix
	  ./configuration.nix
          ./hosts/stormlight/hardware-configuration.nix
        ];
      };
    };
  };
}
