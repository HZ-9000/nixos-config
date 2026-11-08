# k3s cluster nodes (Proxmox VMs): one nixosConfiguration per entry in
# vars/k8s.nix. No home-manager; the nodes are headless servers.
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
  nixosConfigurations = lib.mapAttrs (
    name: node:
    mylib.nixosSystem {
      inherit
        inputs
        lib
        system
        genSpecialArgs
        myvars
        ;
      nixos-modules =
        (map mylib.relativeToRoot [
          "hosts/k8s"
          "modules/nixos/k8s"
        ])
        ++ [
          inputs.disko.nixosModules.disko
          {
            networking.hostName = name;
            modules.k8s = {
              inherit (node) role address;
            };
          }
        ];
    }
  ) myvars.k8s.nodes;

  # Deployment settings only; outputs/default.nix takes the modules from
  # nixosConfigurations above, so colmena deploys exactly what `just test` evaluates.
  colmena = lib.mapAttrs (
    _: node:
    mylib.colmenaSystem {
      targetHost = node.address;
      tags = [ node.role ];
    }
  ) myvars.k8s.nodes;
}
