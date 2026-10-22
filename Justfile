# List all the just commands
default:
    @just --list

# ==============================================================================
# Nix Maintenance
# ==============================================================================

# Run eval tests
[group('nix')]
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose

# Update all the flake inputs
[group('nix')]
up:
    nix flake update --commit-lock-file

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# remove all old generations
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  # Wipe out NixOS's history
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
  # Wipe out home-manager's history
  nix profile wipe-history --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager"

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d


[group('nix')]
fmt:
  # format the nix files in this repo with the flake's formatter (nixfmt-tree)
  nix fmt

# Enter a shell session which has all the necessary tools for this flake
[linux]
[group('nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim

# ==============================================================================
# Desktop Deployment
# ==============================================================================

[linux]
[group('desktop')]
switch flake_name:
  sudo nixos-rebuild switch --flake "{{ justfile_directory() }}#{{ flake_name }}" --accept-flake-config

# Rebuild a nix-darwin host. Use darwin-bootstrap for the very first activation.
[macos]
[group('desktop')]
darwin-switch flake_name:
  sudo darwin-rebuild switch --flake "{{ justfile_directory() }}#{{ flake_name }}" --accept-flake-config

# First activation on a Mac, before darwin-rebuild exists in PATH.
[macos]
[group('desktop')]
darwin-bootstrap flake_name:
  sudo nix run nix-darwin/master#darwin-rebuild \
    --extra-experimental-features "nix-command flakes" \
    -- switch --flake "{{ justfile_directory() }}#{{ flake_name }}" --accept-flake-config

# ==============================================================================
# Kubernetes nodes (Proxmox VMs)
# ==============================================================================

# First install of a k8s node onto a VM booted from the NixOS ISO (see hosts/k8s/README.md)
[linux]
[group('k8s')]
k8s-install node installer_ip:
  nix run github:nix-community/nixos-anywhere -- \
    --flake "{{ justfile_directory() }}#{{ node }}" \
    --extra-files "{{ justfile_directory() }}/extra" \
    --target-host "root@{{ installer_ip }}"

# Deploy config to an installed k8s node; address is read from vars/k8s.nix
[group('k8s')]
k8s-switch node:
  nixos-rebuild switch --flake "{{ justfile_directory() }}#{{ node }}" \
    --target-host "root@$(nix eval --raw --file {{ justfile_directory() }}/vars/k8s.nix 'nodes.{{ node }}.address')" \
    --build-host localhost
