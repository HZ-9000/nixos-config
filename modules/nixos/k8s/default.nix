# Common policy for the k3s nodes (Proxmox VMs). Per-node values (hostname,
# role, address) are set by outputs/x86_64-linux/src/k8s.nix; cluster-wide
# values come from vars/k8s.nix. Deliberately does not use modules/nixos/base
# wholesale: that pulls in agenix passwords, btrfs/btrbk and the desktop user.
{ mylib, ... }:
{
  imports = [
    ../base/i18n.nix
    ../base/nix.nix
    ../base/ssh.nix
    ../../base/nix.nix
  ]
  ++ mylib.scanPaths ./.;
}
