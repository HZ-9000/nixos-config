# k8s nodes (Proxmox)

Six identical Proxmox VMs running [k3s](https://k3s.io) with embedded etcd (HA):

| Host | Role | Address |
|------|------|---------|
| `k8s-master-1` | server, runs `--cluster-init` | see `vars/k8s.nix` |
| `k8s-master-2`, `k8s-master-3` | server (join master-1) | |
| `k8s-worker-1` … `k8s-worker-3` | agent | |

Everything cluster-wide (node list, addresses, gateway, disk, token path) is in
[`vars/k8s.nix`](../../vars/k8s.nix). Masters are tainted `NoSchedule`, so
workloads land on the workers.

## Before first deploy

1. Edit `vars/k8s.nix`: the addresses and gateway are placeholders.
2. Add your public key(s) to `mainSshAuthorizedKeys` in `vars/default.nix`. The
   nodes have no password login, and the build asserts the list is non-empty.

## Proxmox VM spec

- BIOS: **OVMF (UEFI)**, machine `q35`, EFI disk with *Pre-Enroll keys* **off**
  (systemd-boot is not signed for Secure Boot).
- Disk: one disk on `scsi0` with controller *VirtIO SCSI single* (appears as
  `/dev/sda`, matching `diskDevice`). 32 GB+ for masters/workers; more for workers.
- NIC: VirtIO on the cluster bridge. Enable the QEMU guest agent.
- CPU `host`, 2+ cores / 4 GB+ RAM for masters, more for workers.
- Boot each from the stock NixOS minimal ISO, set a root password (or add your
  key) so it is reachable over SSH.

## Install

```bash
# one token shared by all nodes
mkdir -p extra/etc/k3s && openssl rand -hex 32 > extra/etc/k3s/token
chmod 700 extra/etc/k3s && chmod 600 extra/etc/k3s/token

# master-1 first, then the other masters, then the workers
nix run github:nix-community/nixos-anywhere -- \
  --flake .#k8s-master-1 --extra-files ./extra \
  --target-host root@<installer-ip>
```

`just k8s-install <node> <installer-ip>` wraps the above. Keep `extra/` out of git
(it is gitignored).

## Day two

The flake also exposes a Colmena hive for these hosts. It requires an explicit
`--on` selector and uses the same host modules as `nixosConfigurations`.
Initial deployment still requires securely placing the shared token on each
node and applying the init master before the other masters and workers. The
cluster manager's automated token delivery and sequencing are not yet ready.

```bash
sudo nixos-rebuild switch --flake .#k8s-master-1 --target-host root@192.168.10.11
# or: just k8s-switch k8s-master-1
```

Fetch a kubeconfig from a master and point it at the API endpoint:

```bash
ssh <user>@<master> sudo cat /etc/rancher/k3s/k3s.yaml
```

## Not done yet

- API server virtual IP (kube-vip/keepalived); `apiEndpoint` currently is master-1.
- Token as an agenix secret (needs a `k3s-token.age` in the nixos-secrets repo)
  instead of a file copied at install time.
- CNI/ingress/LB choices (k3s defaults: flannel, traefik, servicelb).
