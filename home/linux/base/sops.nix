{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../base/sops.nix
  ];

  sops.age.keyFile = "/etc/age/keys.txt";
}
