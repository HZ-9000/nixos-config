# Connectivity info for Linux VM
NIXADDR := "unset"
NIXPORT := "22"
NIXUSER := "delta"

# The name of the nixosConfiguration in the flake
NIXNAME := "parallels"

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"


# This builds the given NixOS configuration and pushes the results to the
# cache. This does not alter the current running system. This requires
# cachix authentication to be configured out of band.
[group('nix')]
cache:
	nix build '.#nixosConfigurations.{{NIXNAME}}.config.system.build.toplevel' --json \
		| jq -r '.[].outputs | to_entries[].value' \
		| cachix push mitchellh-nixos-config

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
[group('vm')]
bootstrap addr: 
	just NIXUSER=root copy {{addr}}
	just NIXUSER=root switch {{addr}}
	ssh {{SSH_OPTIONS}} -p {{NIXPORT}} {{NIXUSER}}@{{addr}} " \
		sudo reboot; \
	"

# copy the Nix configurations into the VM.
[group('vm')]
copy addr:
	rsync -av -e 'ssh {{SSH_OPTIONS}} -p {{NIXPORT}}' \
		--rsync-path="sudo rsync" \
		{{justfile_directory()}}/ {{NIXUSER}}@{{addr}}:/nix-config
	ssh {{SSH_OPTIONS}} -p {{NIXPORT}} {{NIXUSER}}@{{addr}} " \
		sudo chown -R root:root /nix-config; \
		sudo chmod -R 755 /nix-config; \
	"

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
[group('vm')]
switch addr:
	ssh {{SSH_OPTIONS}} -p {{NIXPORT}} {{NIXUSER}}@{{addr}} " \
		sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake \"/nix-config#{{NIXNAME}}\" \
	"
