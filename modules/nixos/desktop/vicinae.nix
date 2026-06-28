{ inputs, ... }:
{
  imports = [
    inputs.vicinae.nixosModules.default
  ];
}
