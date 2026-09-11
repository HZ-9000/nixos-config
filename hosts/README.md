# Hosts

Per-machine hardware, storage, and system state lives under `hosts/<hostname>/`.
Reusable policy and opt-in capabilities live under `modules/`.

## NixOS

| Host | Architecture | Notes |
|------|--------------|-------|
| `storm` | x86_64-linux | Ryzen 7-9700x + RX 7900XTX, preservation, Secure Boot |
| `stormlight` | x86_64-linux | Framework AMD AI 300, preservation, Secure Boot |
| `squall` | x86_64-linux | Lenovo Yoga 7i, Catppuccin |
| `parallels` | aarch64-linux | Parallels VM |

Deploy a NixOS host:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

When using a local nixos-secrets checkout, add `--override-input nixos-secrets path:./nixos-secrets`.

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

## Age key bootstrap (NixOS)

Before the first rebuild that uses sops-nix, install the host's age private key:

```bash
sudo mkdir -p /etc/age
sudo age-keygen -o /etc/age/keys.txt
```

Copy the public key (`age-keygen -y /etc/age/keys.txt`) into `nixos-secrets/keys/<hostname>.age.pub` on your deploy machine, add it to `nixos-secrets/.sops.yaml`, and run:

```bash
cd nixos-secrets && sops updatekeys secrets.yaml
```

For **parallels**, `just bootstrap` runs `just secrets` to install `/etc/age/keys.txt` from `nixos-secrets/keys/parallels.age` before the first sops-enabled switch. Run this manually after `just copy` if you only need to refresh keys.

Each NixOS host's private key must match the corresponding `nixos-secrets/keys/<hostname>.age.pub` in the private secrets repo. Host private keys stay on the machine at `/etc/age/keys.txt` only.

## Secure Boot keys (storm and stormlight)

Lanzaboote keys are machine-local and must not be committed. Put Storm's MSI
firmware in Custom/setup mode by clearing its Secure Boot variables. Put
Stormlight's Framework firmware in setup mode through its Secure Boot menu.
Then boot with Secure Boot disabled and run:

```bash
nix shell nixpkgs#sbctl
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
sudo nixos-rebuild switch --flake .#<hostname>
sudo sbctl verify
```

Both hosts preserve `/var/lib/sbctl`. Enable Secure Boot only after `sbctl
verify` reports the expected signed EFI files.

## Age key bootstrap (tempest)

**tempest** uses the deploy key at `~/.config/sops/age/keys.txt` for home-manager sops (not `/etc/age/keys.txt`). See the [nixos-secrets README](https://github.com/HZ-9000/nixos-secrets) for full secrets workflow documentation.
