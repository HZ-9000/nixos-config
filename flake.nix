{
  inputs = {
    # Use the Nixpkgs version that matches your system.stateVersion
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    # Replace 'nixos' with your actual system's hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Or "aarch64-linux" for ARM
      modules = [
        # Import your existing configuration.nix
	./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
