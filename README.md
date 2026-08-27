# nixos-config

Personal NixOS and nix-darwin flake with home-manager, built around a shared desktop stack (Niri) on Linux and per-host hardware configuration.

Format Nix files:

```bash
nix fmt
```

Open a dev shell with `sops` and `age`:

```bash
nix develop
```

## Secrets

Encrypted secrets live in the private [nixos-secrets](https://github.com/HZ-9000/nixos-secrets) repository, fetched as a flake input (`flake = false`). This repo only declares which secrets it consumes via sops-nix modules.

Clone nixos-secrets alongside this repo for local editing, or rely on flake fetch over SSH:

```bash
git clone git@github.com:HZ-9000/nixos-secrets.git
```

All setup, key generation, and `sops` commands are documented in the nixos-secrets README.

When using a local checkout instead of fetching over SSH:

```bash
nix eval .#evalTests --accept-flake-config \
  --override-input nixos-secrets path:./nixos-secrets

sudo nixos-rebuild switch --flake .#storm \
  --override-input nixos-secrets path:./nixos-secrets

darwin-rebuild switch --flake .#tempest \
  --override-input nixos-secrets path:./nixos-secrets
```

## Secure Boot (storm and stormlight)

Lanzaboote is enabled for the two ephemeral Btrfs hosts. Its signing keys live
only on each machine at sbctl's current default, `/var/lib/sbctl`, which the
preservation module keeps under `/persistent`.

Prepare setup mode first:

- **storm:** In MSI Advanced Mode, open Settings → Security → Secure Boot,
  choose Custom mode, delete the existing Secure Boot variables, save, and
  reboot without enabling Secure Boot.
- **stormlight:** In the Framework firmware's Secure Boot menu, clear the
  existing keys or select setup mode, then boot with Secure Boot disabled.

Create and enroll the machine-local keys before the first Lanzaboote rebuild:

```bash
nix shell nixpkgs#sbctl
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
sudo nixos-rebuild switch --flake .#<storm-or-stormlight>
sudo sbctl verify
```

After `sbctl verify` succeeds, reboot into firmware setup and enable Secure
Boot. Firmware labels vary by version; do not clear enrolled firmware keys
again unless `/var/lib/sbctl` has been backed up.

## macOS bootstrap (tempest)

First-time nix-darwin install (requires root for system activation):

```bash
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#tempest
```

Subsequent rebuilds:

```bash
darwin-rebuild switch --flake .#tempest
```

Ensure your deploy age key exists at `~/.config/sops/age/keys.txt` before enabling sops-backed home-manager modules. See the nixos-secrets README.

## Components

| | NixOS (Wayland) |
| --- | --- |
| **Compositor** | [Niri][Niri] |
| **App launcher** | [Vicinae][Vicinae] |
| **Status bar / notifications / lock screen** | [noctalia-shell][noctalia-shell] |
| **Terminal emulator** | [Ghostty][Ghostty] / [Kitty][Kitty] |
| **Browser** | [Zen Browser][Zen] |
| **Color scheme** | [catppuccin-nix][catppuccin-nix] |
| **Network management** | [NetworkManager][NetworkManager] |
| **Bluetooth** | Blueman |
| **Audio** | PipeWire |
| **System resource monitor** | [btop][btop] / Mission Center |
| **File manager** | [Nemo][Nemo] / [Thunar][Thunar] |
| **Shell** | [Nushell][Nushell] + [Starship][Starship] |
| **Editors / IDE** | [Cursor][Cursor] / [Zed][Zed] / [Neovim][Neovim] / [Rider][Rider] |
| **Game development** | [Godot][Godot] + [.NET SDK][dotnet] |
| **Clipboard** | [Vicinae][Vicinae] + [cliphist][cliphist] + [wl-clipboard][wl-clipboard] |
| **Screenshot / color picker** | grim + slurp / [wl-color-picker][wl-color-picker] / swappy |
| **Screen recording** | [wf-recorder][wf-recorder] |
| **Fonts** | [Nerd fonts][Nerd fonts] |
| **Cursor theme** | Bibata Modern Ice |
| **Desktop integration** | xdg-desktop-portal-gnome + xdg-desktop-portal-gtk |
| **Nix tooling** | [nh][nh] / nix-output-monitor / nixd / nixfmt |
| **Version control** | Git / [gh][gh] / [Lazygit][Lazygit] |

[Niri]: https://github.com/YaLTeR/niri
[noctalia-shell]: https://github.com/noctalia-dev/noctalia-shell
[Ghostty]: https://ghostty.org/
[Kitty]: https://github.com/kovidgoyal/kitty
[Zen]: https://zen-browser.app/
[catppuccin-nix]: https://github.com/catppuccin/nix
[NetworkManager]: https://wiki.gnome.org/Projects/NetworkManager
[btop]: https://github.com/aristocratos/btop
[Nemo]: https://github.com/linuxmint/nemo
[Thunar]: https://gitlab.xfce.org/xfce/thunar
[Nushell]: https://www.nushell.sh/
[Starship]: https://github.com/starship/starship
[Cursor]: https://cursor.com/
[Zed]: https://zed.dev/
[Neovim]: https://github.com/neovim/neovim
[Rider]: https://www.jetbrains.com/rider/
[Godot]: https://godotengine.org/
[dotnet]: https://dotnet.microsoft.com/
[Vicinae]: https://github.com/vicinaehq/vicinae
[cliphist]: https://github.com/sentriz/cliphist
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[wl-color-picker]: https://github.com/duducm2/wl-color-picker
[wf-recorder]: https://github.com/ammaraskar/wf-recorder
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[nh]: https://github.com/viperML/nh
[gh]: https://cli.github.com/
[Lazygit]: https://github.com/jesseduffield/lazygit

## Repository layout

```
.
├── flake.nix
├── outputs/
│   ├── default.nix
│   └── <system>/{default.nix,src/,tests/}
├── hosts/<hostname>/       # Hardware, storage, and machine-specific state
├── modules/
│   ├── base/               # Cross-platform system policy
│   ├── nixos/
│   │   ├── base/           # Always-on NixOS policy
│   │   ├── desktop/        # Desktop role
│   │   └── optional/       # Explicit host capabilities
│   └── darwin/             # nix-darwin policy
├── home/
│   ├── base/{core,tui,gui}/
│   ├── linux/{base,gui}/
│   ├── darwin/
│   └── hosts/{linux,darwin}/
├── lib/                    # System constructors and path helpers
├── vars/                   # Shared identity and path constants
└── nixos-installer/        # Minimal installer flake
```

## How it fits together

1. **`flake.nix`** declares inputs (nixpkgs, home-manager, nix-darwin, Niri, Vicinae, Catppuccin, …) and delegates to `outputs/`.
2. **`outputs/<arch>/src/<host>.nix`** defines a `nixosConfiguration` or `darwinConfiguration` by combining:
   - `hosts/<hostname>/` — machine-specific settings
   - `modules/nixos/desktop.nix` or `modules/darwin/` — role/platform modules
   - explicit `modules/nixos/optional/` capabilities where needed
   - optional flake input modules (e.g. nixos-hardware, Catppuccin)
   - `home/hosts/linux/<hostname>.nix` or `home/hosts/darwin/<hostname>.nix` — home-manager config
3. **`lib/nixosSystem.nix`** and **`lib/macosSystem.nix`** wrap system builders and attach home-manager for `vars.username`.
4. Home Manager composes portable `home/base/` modules, platform modules, then thin host entrypoints.

## References

Configs and resources that informed this repository's structure:

- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
