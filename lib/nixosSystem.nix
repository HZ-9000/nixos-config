{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager agenix;
in
nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  modules =
    nixos-modules
    ++ [ agenix.nixosModules.default ]
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "home-manager.backup";
          extraSpecialArgs = specialArgs;
          users."${myvars.username}".imports = home-modules;
        };
      }
    ]);
}
