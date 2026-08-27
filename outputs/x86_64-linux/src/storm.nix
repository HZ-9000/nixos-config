{
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}:
{
  nixosConfigurations.storm = mylib.nixosSystem {
    inherit
      inputs
      lib
      system
      genSpecialArgs
      myvars
      ;
    nixos-modules =
      (map mylib.relativeToRoot [
        # host-specific hardware
        "hosts/storm"
        # system modules
        "modules/nixos/desktop.nix"
        # host capabilities
        "modules/nixos/optional/btrbk.nix"
        "modules/nixos/optional/preservation.nix"
        "modules/nixos/optional/secure-boot.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
      ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/storm.nix"
    ];
  };
}
