{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.nixos-secrets}/secrets.yaml";
    age.keyFile = "/etc/age/keys.txt";
  };
}
