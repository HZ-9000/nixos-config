# Connectivity info for Linux VM
NIXADDR := "UNSET"
NIXPORT := "22"
NIXUSER := "root"

# The name of the nixosConfiguration in the flake
NIXNAME := "parallels"

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# List all the just commands
default:
    @just --list

# Update all the flake inputs
[group('nix')]
up:
    nix flake update --commit-lock-file --extra-experimental-features nix-command --extra-experimental-features flakes

# This builds the given NixOS configuration and pushes the results to the
# cache. This does not alter the current running system. This requires
# cachix authentication to be configured out of band.
[group('nix')]
cache:
    nix build '.#nixosConfigurations.{{ NIXNAME }}.config.system.build.toplevel' --json \
    	| jq -r '.[].outputs | to_entries[].value' \
    	| cachix push mitchellh-nixos-config

[group('vm')]
bootstrap0:
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} root@{{ NIXADDR }} " \
    	parted /dev/sda -- mklabel gpt; \
    	parted /dev/sda -- mkpart primary 512MB -8GB; \
    	parted /dev/sda -- mkpart primary linux-swap -8GB 100\%; \
    	parted /dev/sda -- mkpart ESP fat32 1MB 512MB; \
    	parted /dev/sda -- set 3 esp on; \
    	sleep 1; \
    	mkfs.ext4 -L nixos /dev/sda1; \
    	mkswap -L swap /dev/sda2; \
    	mkfs.fat -F 32 -n boot /dev/sda3; \
    	sleep 1; \
    	mount /dev/disk/by-label/nixos /mnt; \
    	mkdir -p /mnt/boot; \
    	mount /dev/disk/by-label/boot /mnt/boot; \
    	nixos-generate-config --root /mnt; \
    	sed --in-place '/system.stateVersion = .*/a \
    		nix.package = pkgs.nixVersions.latest;\n \
    		nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
    		services.openssh.enable = true;\n \
    		services.openssh.settings.PasswordAuthentication = true;\n \
    		services.openssh.settings.PermitRootLogin = \"yes\";\n \
    		users.users.root.initialPassword = \"root\";\n \
    	' /mnt/etc/nixos/configuration.nix; \
    	nixos-install --no-root-passwd && reboot; \
    "

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
[group('vm')]
bootstrap:
    just NIXUSER=root copy
    just NIXUSER=root secrets
    just NIXUSER=root switch
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} {{ NIXUSER }}@{{ NIXADDR }} " \
    	sudo reboot; \
    "

# copy the Nix configurations into the VM.
[group('vm')]
copy:
    rsync -av -e 'ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }}' \
    	--exclude='.git/' \
    	--rsync-path="sudo rsync" \
    	{{ justfile_directory() }}/ {{ NIXUSER }}@{{ NIXADDR }}:/nix-config
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} {{ NIXUSER }}@{{ NIXADDR }} " \
    "

# install the host age key on the VM for sops-nix (requires nixos-secrets checkout locally).
[group('vm')]
secrets:
    #!/usr/bin/env bash
    set -euo pipefail
    key="{{ justfile_directory() }}/nixos-secrets/keys/{{ NIXNAME }}.age"
    if [[ ! -f "$key" ]]; then
    	echo "error: missing host age key: $key" >&2
    	echo "Clone nixos-secrets alongside this repo or generate keys per nixos-secrets/README.md" >&2
    	exit 1
    fi
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} {{ NIXUSER }}@{{ NIXADDR }} " \
    	getent group keys >/dev/null || groupadd --system keys; \
    	mkdir -p /etc/age && chmod 700 /etc/age \
    "
    scp {{ SSH_OPTIONS }} -P {{ NIXPORT }} "$key" {{ NIXUSER }}@{{ NIXADDR }}:/etc/age/keys.txt
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} {{ NIXUSER }}@{{ NIXADDR }} " \
    	chown root:keys /etc/age/keys.txt && chmod 640 /etc/age/keys.txt \
    "

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
[group('vm')]
switch:
    ssh {{ SSH_OPTIONS }} -p {{ NIXPORT }} {{ NIXUSER }}@{{ NIXADDR }} " \
    	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake \"/nix-config#{{ NIXNAME }}\" \
    		--accept-flake-config \
    		--override-input nixos-secrets path:/nix-config/nixos-secrets \
    "
