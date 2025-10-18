{
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    inputs@{ self, nixpkgs, nixos-hardware, catppuccin, ... }:
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
        stormlight = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
     	      nixos-hardware.nixosModules.framework-amd-ai-300-series
            ./hosts/stormlight
             catppuccin.nixosModules.catppuccin
          ];
          specialArgs = {
            host = "laptop";
            inherit self inputs username;
          };
        };

        storm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/storm
          ];
          specialArgs = {
            host = "desktop";
            inherit self inputs username;
          };
        };
    };
  };
}
