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
# Secrets (agenix, ./nixos-secrets)
# ==============================================================================

# Re-encrypt all secrets, keeping values; with a host, add it first (`just secrets-rekey storm`)
[linux]
[group('secrets')]
[positional-arguments]
secrets-rekey *args:
  @"{{ justfile_directory() }}/scripts/secrets-rekey.nu" "$@"

# Fallback when nothing can decrypt: add this host's SSH key, re-encrypt all secrets from new values
[linux]
[group('secrets')]
secrets-regen host=`hostname`:
  @"{{ justfile_directory() }}/scripts/secrets-regen.nu" "{{ host }}"

# ==============================================================================
# Kubernetes nodes (Proxmox VMs)
# ==============================================================================

# Generate an age identity per k8s node in extra/<node>/ (kept if present) and print the public keys
[linux]
[group('k8s')]
k8s-keys:
  #!/usr/bin/env bash
  set -euo pipefail
  cd "{{ justfile_directory() }}"
  nodes=$(nix eval --raw --file vars/k8s.nix nodes --apply 'n: toString (builtins.attrNames n)')
  for node in $nodes; do
    dir="extra/$node/etc/age"
    if [ ! -f "$dir/keys.txt" ]; then
      mkdir -p "$dir" && chmod 700 "$dir"
      (umask 077 && nix shell nixpkgs#age -c age-keygen -o "$dir/keys.txt" 2>/dev/null)
    fi
    printf '%s = "%s";\n' "$node" "$(nix shell nixpkgs#age -c age-keygen -y "$dir/keys.txt")"
  done

# First install of a k8s node onto a VM booted from the NixOS ISO (see hosts/k8s/README.md)
[linux]
[group('k8s')]
k8s-install node installer_ip:
  nix run github:nix-community/nixos-anywhere -- \
    --flake "{{ justfile_directory() }}#{{ node }}" \
    --extra-files "{{ justfile_directory() }}/extra/{{ node }}" \
    --target-host "root@{{ installer_ip }}"

# Deploy config to an installed k8s node; address is read from vars/k8s.nix
[group('k8s')]
k8s-switch node:
  nixos-rebuild switch --flake "{{ justfile_directory() }}#{{ node }}" \
    --target-host "root@$(nix eval --raw --file {{ justfile_directory() }}/vars/k8s.nix 'nodes.{{ node }}.address')" \
    --build-host localhost

# Deploy installed k8s nodes with colmena: `just k8s-col master`, `just k8s-col worker`,
# or a single node with `just k8s-col k8s-worker-2`
[group('k8s')]
k8s-col target mode="switch":
  nix run --inputs-from "{{ justfile_directory() }}" colmena -- apply \
    --on "{{ if target == "master" { "@master" } else if target == "worker" { "@worker" } else { target } }}" \
    {{ mode }}
