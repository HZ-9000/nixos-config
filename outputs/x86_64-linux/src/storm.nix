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
  nixosConfigurations.storm = mylib.nixosSystem {
    inherit inputs lib system genSpecialArgs myvars;
    nixos-modules = map mylib.relativeToRoot [
      # host-specific hardware
      "hosts/storm"
      # system modules
      "modules/nixos/desktop.nix"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/storm.nix"
    ];
  };
}
