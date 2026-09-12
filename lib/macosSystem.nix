{
  inputs,
  lib,
  system,
  genSpecialArgs,
  darwin-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}:
let
  inherit (inputs) darwin home-manager nixpkgs;
in
darwin.lib.darwinSystem {
  inherit specialArgs;
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  modules =
    [
      { nixpkgs.hostPlatform = system; }
    ]
    ++ darwin-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.darwinModules.home-manager
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
