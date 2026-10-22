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
}
