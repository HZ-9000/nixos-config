{
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}@args:
{
  nixosConfigurations.parallels = mylib.nixosSystem {
    inherit inputs lib system genSpecialArgs myvars;
    nixos-modules = map mylib.relativeToRoot [
      # host-specific hardware
      "hosts/parallels"
      # system modules
      "modules/nixos/desktop.nix"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/parallels.nix"
    ];
  };
}
