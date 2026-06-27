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
  nixosConfigurations.squall = mylib.nixosSystem {
    inherit inputs lib system genSpecialArgs myvars;
    nixos-modules =
      (map mylib.relativeToRoot [
        # host-specific hardware
        "hosts/squall"
        # system modules
        "modules/nixos/desktop.nix"
      ])
      ++ [
        inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        inputs.catppuccin.nixosModules.catppuccin
      ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/squall.nix"
    ];
  };
}
