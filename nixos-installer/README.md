# NixOS installer

A minimal flake for the first install of [storm](../hosts/storm) and
[stormlight](../hosts/stormlight). It imports the same `hosts/<host>` module as the main flake
(hardware, disk layout, preservation) plus the base modules, but skips the desktop, agenix and
lanzaboote. It includes `sbctl`, so the Secure Boot keys exist before the first switch to the
main config.

## Why this flake exists

The main flake is heavy and slow to deploy. This minimal flake helps to:

1. Adjust and verify `hardware-configuration.nix` and disk layout before deploying the main flake.
2. Test preservation, TPM 2.0, and encryption on a fresh install.

Disk layout is **declarative** via [disko](https://github.com/nix-community/disko). The
`flake.lock` here is ignored on purpose, so each install resolves fresh inputs; check that
`nixpkgs` in [flake.nix](./flake.nix) is on the same release as the main flake.

Check that it still evaluates with `just test storm` (or `just test stormlight`).

## Steps to deploy

The examples use `storm`; substitute `stormlight` as needed.

1. Create a USB install medium from the official NixOS ISO and boot from it.
2. Review `../hosts/<host>/hardware-configuration.nix` against the target machine. If the
   hardware differs, print a fresh one after the disk is mounted with
   `nixos-generate-config --root /mnt --no-filesystems --show-hardware-config` (disko owns the
   file systems) and merge it in.

### 1. Partition and mount with disko

The layout is defined in [../hosts/common/disko-fs.nix](../hosts/common/disko-fs.nix), with the
disk set per host in [../hosts/storm/disko-fs.nix](../hosts/storm/disko-fs.nix): a 600 MiB ESP,
LUKS, and Btrfs subvolumes. Root is tmpfs; [preservation](https://github.com/nix-community/preservation)
uses `/persistent`.

```bash
git clone https://github.com/HZ-9000/nixos-config.git
cd nixos-config/nixos-installer

sudo su

# Encrypts the root partition with LUKS2 (prompts for a passphrase) and mounts at /mnt.
# WARNING: destroys all data on the target disk.
nix run github:nix-community/disko -- --mode destroy,format,mount ../hosts/storm/disko-fs.nix

# Mount only (e.g. after first format, without wiping):
# nix run github:nix-community/disko -- --mode mount ../hosts/storm/disko-fs.nix

# Set up automatic unlocking with the TPM 2.0 chip (find the partition with `lsblk -f`).
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/<encrypted-disk-part-path>
```

### 2. Install NixOS

Both `root` and the main user read their password hash from `/persistent/etc/installer-password`
until the first switch to the main config, where agenix takes over (see
[configuration.nix](./configuration.nix)):

```bash
mkdir -p /mnt/persistent/etc
nix run nixpkgs#mkpasswd -- -m yescrypt > /mnt/persistent/etc/installer-password
chmod 600 /mnt/persistent/etc/installer-password

# From nixos-config/nixos-installer
nixos-install --root /mnt --flake .#storm --no-root-password
```

### 3. Keep the checkout and reboot

`/` is tmpfs, so anything written outside `/mnt/persistent` is gone after the reboot. A fresh
install needs nothing else copied: preservation commits the machine ID to
`/persistent/etc/machine-id` on first boot, and sshd creates its host keys in the preserved
`/etc/ssh`. When migrating from an old disk, copy its data into `/mnt/persistent` now.

```bash
# Put the checkout where preservation mounts ~/nixos-config from.
mkdir -p /mnt/persistent/home/hz-9000
cp -r .. /mnt/persistent/home/hz-9000/nixos-config
umount -R /mnt
reboot
```

## Deploying the Main Flake After Installation

After the first boot:

### 1. Set up the GitHub SSH key

The main flake pulls the private `nixos-secrets` repo over SSH, so the machine needs a key
GitHub accepts. `~/.ssh` is preserved, so the key survives reboots.

These commands are nushell, the login shell. `programs.ssh.startAgent` runs the agent, and
[../modules/nixos/base/nushell.nix](../modules/nixos/base/nushell.nix) loads the NixOS login
environment (including `SSH_AUTH_SOCK`) into nushell. Check with `ssh-add -l`: "The agent has
no identities" is fine; "Could not open a connection" means the variable is missing (on an
install made before that file existed, set it by hand with
`$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"`).

```nu
sudo chown -R hz-9000:users ~/nixos-config
# It was cloned over HTTPS; push over SSH from now on.
git -C ~/nixos-config remote set-url origin git@github.com:HZ-9000/nixos-config.git

# Generate a key named after the host (use a passphrase) and load it into the agent.
# The agent forgets it on reboot; `AddKeysToAgent yes` re-adds it the first time ssh uses it.
let host = (sys host).hostname
let key = $"($env.HOME)/.ssh/($host)"
ssh-keygen -t ed25519 -a 256 -C $"hz-9000@($host)" -f $key
ssh-add $key

# Upload it with the gh CLI (installed by this flake). The admin:public_key scope
# is what lets gh add SSH keys; --skip-ssh-key stops gh offering to make its own.
# --web needs no local browser: gh prints a one-time code; enter it at
# https://github.com/login/device on your phone or another computer.
gh auth login --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key
gh ssh-key add $"($key).pub" --title $host

# `just switch` runs nixos-rebuild through sudo, which keeps SSH_AUTH_SOCK, so root
# fetches over your agent.
# GitHub's host key is preinstalled (modules/nixos/base/ssh.nix), so neither asks to trust it.
ssh -T git@github.com        # should greet you by username
sudo ssh -T git@github.com   # same greeting: root uses your agent
```

[../home/base/tui/ssh.nix](../home/base/tui/ssh.nix) sets `IdentitiesOnly` for `github.com`;
[../home/linux/default.nix](../home/linux/default.nix) points it at `~/.ssh/<hostname>`, so keep
the key named after the host.

To let this host log in as root on the other machines (desktops over the tailnet, and the k8s
nodes), add the `.pub` line to `mainSshAuthorizedKeys` or `secondaryAuthorizedKeys` in
[../vars/default.nix](../vars/default.nix); it takes effect on each machine's next switch.

### 2. Add the host to the agenix secrets

Hosts decrypt secrets with their SSH host key, `/persistent/etc/ssh/ssh_host_ed25519_key`,
which sshd creates on first boot. The new host can't decrypt anything until an existing host
re-encrypts the secrets for it.

The other machine can't reach the new host yet: the installer system's firewall keeps port 22
closed and it isn't on the tailnet. So `ssh-keyscan` won't work; copy the key over instead.
On the new host:

```nu
open /etc/ssh/ssh_host_ed25519_key.pub
```

On a machine that can already decrypt (e.g. stormlight), pass that line as the second
argument (quoted: it contains spaces):

```nu
cd ~/nixos-config
just secrets-rekey storm "ssh-ed25519 AAAA..."
git -C nixos-secrets push
```

Then, on the new host:

```nu
cd ~/nixos-config
nix flake update nixos-secrets
```

If no machine can decrypt (all hosts lost, no deploy key), run `just secrets-regen storm` on the
new host instead. It enters fresh passwords and a GitHub token, so every host's values change.

### 3. Create the Secure Boot signing keys

[../hosts/common/secure-boot.nix](../hosts/common/secure-boot.nix) replaces
systemd-boot with [lanzaboote](https://github.com/nix-community/lanzaboote),
which signs the kernel and boot files with keys stored in `/var/lib/sbctl`.
Lanzaboote won't install unsigned files, so without keys the first switch fails at
the bootloader step. Create them now with `sbctl` (installed by this flake). They are
local to this machine; never commit them. `/var/lib/sbctl` is preserved, so they
survive reboots.

```bash
sudo sbctl create-keys
```

### 4. Deploy the main config

```bash
cd ~/nixos-config
just switch storm
```

If it fails while installing the bootloader, check that `sudo sbctl status` shows the keys
as installed (step 3), then switch again.

From now on the agenix passwords apply; `/persistent/etc/installer-password` is no longer read
and can be deleted.

Join the tailnet; SSH between the machines only works over it:

```nu
sudo tailscale up
```

### 5. Set up Secure Boot

Keep Secure Boot **disabled** in firmware until the end of this step.

1. **Check that lanzaboote is active.** It should now be the bootloader:

    ```bash
    bootctl status   # "Product" should mention lanzaboote
    ```

2. **Confirm that everything is signed:**

    ```bash
    sudo sbctl verify   # every lanzaboote/kernel EFI file should be "signed"
    ```

    The unsigned `systemd-bootx64.efi` / `BOOTX64.EFI` files that lanzaboote
    doesn't use can be ignored.

3. **Put the firmware in Setup Mode.** Reboot into the firmware settings:
    - **storm** (MSI): Secure Boot → set mode to *Custom*, then delete or clear all
      Secure Boot keys.
    - **stormlight** (Framework): Secure Boot → *Erase all Secure Boot Settings*
      (puts it in Setup Mode).

    Save, boot back into NixOS, and confirm:

    ```bash
    sudo sbctl status   # "Setup Mode: Enabled"
    ```

4. **Enroll the keys.** `--microsoft` also enrolls Microsoft's certificates.
   Keep that flag: without it, firmware option ROMs (e.g. the GPU) may fail to load
   and the machine may not boot.

    ```bash
    sudo sbctl enroll-keys --microsoft
    ```

5. **Enable Secure Boot.** Reboot into the firmware, turn Secure Boot on, and boot
   NixOS. Then check:

    ```bash
    sudo sbctl status   # "Secure Boot: Enabled", "Setup Mode: Disabled"
    ```

6. **Re-enroll TPM unlocking.** Enabling Secure Boot changes PCR 7, so the LUKS
   TPM slot made during install stops matching and you will get a passphrase
   prompt. Replace the slot:

    ```bash
    sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7 /dev/<encrypted-disk-part-path>
    ```

If the machine doesn't boot after enabling Secure Boot, disable it in the firmware,
boot, and check `sudo sbctl verify` again.

## Changing the LUKS2 Passphrase

```bash
# Test current passphrase
sudo cryptsetup --verbose open --test-passphrase /path/to/device

# Change passphrase
sudo cryptsetup luksChangeKey /path/to/device

# Verify
sudo cryptsetup --verbose open --test-passphrase /path/to/device
```

## References

Background:

- [NixOS manual installation](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning)
- [dm-crypt / Encrypting an entire system (Arch)](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system)
- [cryptsetup FAQ](https://gitlab.com/cryptsetup/cryptsetup/wikis/FrequentlyAskedQuestions)
