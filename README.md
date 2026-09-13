<h2 align="center">NixOS Config</h2>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

This repository contains a NixOS configuration that builds the following:

1. Linux systems using the components listed below.
2. macOS systems using nix-darwin and the shared Home Manager configuration.

See [./hosts](./hosts) for details of each host.

## Components

| | NixOS (Wayland) |
| --- | --- |
| **Window Manager** | [Niri][Niri] |
| **App launcher** | [Vicinae][Vicinae] |
| **Status bar / notifications / lock screen** | [noctalia-shell][noctalia-shell] |
| **Terminal emulator** | [Ghostty][Ghostty] / [Kitty][Kitty] |
| **Browser** | [Zen Browser][Zen] |
| **Color scheme** | [catppuccin-nix][catppuccin-nix] |
| **Network management** | [NetworkManager][NetworkManager] |
| **System resource monitor** | [btop][btop] / Mission Center |
| **File manager** | [Nemo][Nemo] / [Thunar][Thunar] |
| **Shell** | [Nushell][Nushell] + [Starship][Starship] |
| **Editors / IDE** | [Zed][Zed] / [Neovim][Neovim] / [Rider][Rider] |
| **Screenshot** | grim + slurp + [Satty][Satty] |
| **Fonts** | [Nerd fonts][Nerd fonts] |
| **Filesystem & Encryption** | tmpfs as `/`, with [Btrfs][Btrfs] subvolumes on a [LUKS][LUKS]-encrypted partition for persistent storage, unlocked with a passphrase |
| **Secure Boot** | [lanzaboote][lanzaboote] |

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
[Zed]: https://zed.dev/
[Neovim]: https://github.com/neovim/neovim
[Rider]: https://www.jetbrains.com/rider/
[Vicinae]: https://github.com/vicinaehq/vicinae
[Satty]: https://github.com/gabm/Satty
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[Btrfs]: https://btrfs.readthedocs.io/
[LUKS]: https://gitlab.com/cryptsetup/cryptsetup/-/blob/main/README.md
[lanzaboote]: https://github.com/nix-community/lanzaboote

## Screenshots

WIP

## Deployment 

Deployment is outlined in [./nixos-installer](./nixos-installer)

**WARNING**: Hardware specific configurations are in place for my specific hardware. IF you are hoping to deploy this configuration 
on your own hardware, you will need to modify the hardware-specific configurations. See [./nixos-installer](./nixos-installer) for more information.

## References

Configs and resources that informed this repository's structure:

- NixOS
  - [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
  - [reo101/rix101](https://github.com/reo101/rix101)

- Theme
  - [43PR/dotfiles](https://github.com/43PR/dotfiles)
  - [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
