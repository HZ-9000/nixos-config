# Opt-in secrets for the k8s nodes: the shared k3s cluster token.
#
# Each node has its own age identity at /etc/age/keys.txt, placed at install
# time by nixos-anywhere (`just k8s-keys`, then `just k8s-install`). See
# hosts/k8s/README.md for creating k3s-token.age in the nixos-secrets repo.
{
  config,
  inputs,
  agenix,
  ...
}:
let
  tokenFile = "${inputs.nixos-secrets}/k3s-token.age";
in
{
  imports = [ agenix.nixosModules.default ];

  assertions = [
    {
      assertion = builtins.pathExists tokenFile;
      message = ''
        nixos-secrets has no k3s-token.age. Create it (hosts/k8s/README.md, "Cluster
        token"), push, and run `nix flake update nixos-secrets`.
      '';
    }
  ];

  age.identityPaths = [ "/etc/age/keys.txt" ];
  age.secrets.k3s-token.file = tokenFile;

  services.k3s.tokenFile = config.age.secrets.k3s-token.path;
}
