# Shared by all k8s nodes: they are identical Proxmox VMs, differing only in
# hostname/role/address (set in outputs/x86_64-linux/src/k8s.nix).
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-fs.nix
  ];

  system.stateVersion = "26.05";
}
