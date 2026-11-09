# k8s nodes (Proxmox)

Six identical Proxmox VMs running [k3s](https://k3s.io) with embedded etcd (HA):

| Host | Role | Notes |
|------|------|-------|
| `k8s-master-1` | server, runs `--cluster-init` | keepalived priority 150 |
| `k8s-master-2`, `k8s-master-3` | server (join master-1) | keepalived priority 140 / 130 |
| `k8s-worker-1` … `k8s-worker-3` | agent (join via the API address) | |

Everything cluster-wide (nodes, addresses, API address, MetalLB range, NIC, disk)
is in [`vars/k8s.nix`](../../vars/k8s.nix). Masters are tainted `NoSchedule`, so
workloads land on the workers.

| Piece | Where | What it does |
|-------|-------|--------------|
| API address | [`modules/nixos/k8s/vip.nix`](../../modules/nixos/k8s/vip.nix) | keepalived (unicast VRRP) on the masters moves `apiEndpoint` to the highest-priority master whose API server is up |
| Load balancers | [`modules/nixos/k8s/metallb.nix`](../../modules/nixos/k8s/metallb.nix) | MetalLB (L2) replaces k3s's servicelb; `LoadBalancer` services get an address from `loadBalancerRange` |
| Ingress | k3s default | traefik, which gets its address from MetalLB |
| CNI | k3s default | flannel (VXLAN) |
| Cluster token | [`secrets/k8s.nix`](../../secrets/k8s.nix) | agenix secret `k3s-token.age`, decrypted with each node's own age key |

## Before first deploy

1. Check `vars/k8s.nix` against your network: node addresses, `apiEndpoint`, and
   `loadBalancerRange` must be unused and outside the DHCP range; `network.interface`
   must match the VM NIC (`ens18` for the first Proxmox virtio NIC).
2. Your public key(s) must be in `mainSshAuthorizedKeys` in `vars/default.nix`. The
   nodes have no password login, and the build asserts the list is non-empty.
3. Create the node keys and the cluster token (below).

### Node keys and cluster token

Every node decrypts the token with its own age identity at `/etc/age/keys.txt`,
which nixos-anywhere copies in at install time.

```bash
# Creates extra/<node>/etc/age/keys.txt for each node (existing keys are kept)
# and prints the public keys. extra/ is gitignored; back it up somewhere safe.
just k8s-keys
```

In the nixos-secrets repo, add those public keys to `secrets.nix` and give the
token its recipients:

```nix
  k8s-master-1 = "age1...";
  # ... one line per node, as printed by `just k8s-keys`
  k8sNodes = [ k8s-master-1 k8s-master-2 k8s-master-3 k8s-worker-1 k8s-worker-2 k8s-worker-3 ];
in
{
  # ...existing secrets...
  "k3s-token.age".publicKeys = k8sNodes ++ [ deploy ];
}
```

Then create the token, push, and update the lock here:

```bash
# in nixos-secrets
openssl rand -hex 32 | agenix -e k3s-token.age
git add secrets.nix k3s-token.age && git commit -m "k3s token" && git push

# in nixos-config
nix flake update nixos-secrets
```

Until `k3s-token.age` exists, building a k8s node fails with an assertion saying so.

## Proxmox VM spec

- BIOS: **OVMF (UEFI)**, machine `q35`, EFI disk with *Pre-Enroll keys* **off**
  (systemd-boot is not signed for Secure Boot).
- Disk: one disk on `scsi0` with controller *VirtIO SCSI single* (appears as
  `/dev/sda`, matching `diskDevice`). 32 GB+; more for workers.
- NIC: VirtIO on the cluster bridge (appears as `ens18`). Enable the QEMU guest agent.
- CPU `host`, 2+ cores / 4 GB+ RAM for masters, more for workers.
- Boot each from the stock NixOS minimal ISO, set a root password (or add your
  key) so it is reachable over SSH.

## Install

Order matters: master-1 first (it creates the cluster and takes the API address),
then the other masters, then the workers.

```bash
just k8s-install k8s-master-1 <installer-ip>
just k8s-install k8s-master-2 <installer-ip>
# ...
```

`k8s-install` runs nixos-anywhere with `--extra-files extra/<node>`, which places
that node's age key.

## Day two

Deploy changes to installed nodes with colmena (masters before workers when both change):

```bash
just k8s-col master            # all masters
just k8s-col worker            # all workers
just k8s-col k8s-worker-2      # one node
just k8s-switch k8s-worker-2   # same, with nixos-rebuild instead
```

Fetch a kubeconfig from a master and point it at the API address:

```bash
ssh hz-9000@192.168.6.11 sudo cat /etc/rancher/k3s/k3s.yaml \
  | sed 's/127.0.0.1/192.168.6.32/' > ~/.kube/config
```

Check the moving parts:

```bash
ip -br addr show ens18                # on a master: the one holding 192.168.6.32 lists it
journalctl -u keepalived              # MASTER/BACKUP transitions
kubectl -n metallb-system get pods
kubectl -n kube-system get svc traefik   # EXTERNAL-IP from loadBalancerRange
```

## Not done yet

- etcd snapshots off the nodes (k3s takes local snapshots by default; nothing ships them elsewhere).
- Persistent storage beyond k3s's local-path provisioner.
