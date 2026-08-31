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
  nixosConfigurations.stormlight = mylib.nixosSystem {
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
        "hosts/stormlight"
        # system modules
        "modules/nixos/desktop.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
        inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        inputs.catppuccin.nixosModules.catppuccin
      ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/stormlight.nix"
    ];
  };
}
