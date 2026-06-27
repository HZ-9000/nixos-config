# Hosts

Per-machine NixOS configuration. Each subdirectory contains `default.nix` and `hardware-configuration.nix` for that machine.

| Host | Architecture | Notes |
|------|--------------|-------|
| `storm` | x86_64-linux | Ryzen 7-9700x + RX 7900XTX |
| `stormlight` | x86_64-linux | Framework AMD AI 300, Catppuccin |
| `squall` | x86_64-linux | Lenovo Yoga 7i, Catppuccin |
| `parallels` | aarch64-linux | Parallels VM |

Deploy a host:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```
