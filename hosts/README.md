# Hosts

Per-machine hardware, storage, and system state lives under `hosts/<hostname>/`.
Reusable policy and opt-in capabilities live under `modules/`.

## NixOS

| Host | Architecture | Notes |
|------|--------------|-------|
| `storm` | x86_64-linux | Ryzen 7-9700x + RX 7900XTX, preservation, Secure Boot |
| `stormlight` | x86_64-linux | Framework AMD AI 300, preservation, Secure Boot |
| `k8s-master-{1,2,3}` | x86_64-linux | k3s servers (HA etcd), Proxmox VMs; see [k8s/](./k8s/README.md) |
| `k8s-worker-{1,2,3}` | x86_64-linux | k3s agents, Proxmox VMs; see [k8s/](./k8s/README.md) |

Deploy a NixOS host:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

For a fresh installation of `storm` or `stormlight`, follow the
[installer guide](../nixos-installer/README.md). It includes the required
machine-specific configuration and credential review before the destructive disk
provisioning step.

## macOS (nix-darwin)

| Host | Architecture | Notes |
|------|--------------|-------|
| `tempest` | aarch64-darwin | Apple Silicon Mac |

First-time install (requires root for system activation):

```bash
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#tempest
```

Subsequent rebuilds:

```bash
darwin-rebuild switch --flake .#tempest
```

## Secure Boot keys (storm and stormlight)

Lanzaboote keys are machine-local and must not be committed. Both hosts preserve
`/var/lib/sbctl`. See
[Set up Secure Boot](../nixos-installer/README.md#3-set-up-secure-boot) in the
installer guide for the full walkthrough, including firmware Setup Mode on each machine.
