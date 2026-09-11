{ config, inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../base/sops.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
}
