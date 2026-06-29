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
  inherit (inputs) darwin home-manager;
in
darwin.lib.darwinSystem {
  inherit system specialArgs;
  modules =
    darwin-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ]);
}
