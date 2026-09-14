# Hosts

Per-machine hardware, storage, and system state lives under `hosts/<hostname>/`.
Reusable policy and opt-in capabilities live under `modules/`.

## NixOS

| Host | Architecture | Notes |
|------|--------------|-------|
| `storm` | x86_64-linux | Ryzen 7-9700x + RX 7900XTX, preservation, Secure Boot |
| `stormlight` | x86_64-linux | Framework AMD AI 300, preservation, Secure Boot |

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

Lanzaboote keys are machine-local and must not be committed. Put Storm's MSI
firmware in Custom/setup mode by clearing its Secure Boot variables. Put
Stormlight's Framework firmware in setup mode through its Secure Boot menu.
Then boot with Secure Boot disabled and run the following only after the first
successful boot of the main flake:

```bash
nix shell nixpkgs#sbctl
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
sudo nixos-rebuild switch --flake .#<hostname>
sudo sbctl verify
```

Both hosts preserve `/var/lib/sbctl`. Enable Secure Boot only after `sbctl
verify` reports the expected signed EFI files.
