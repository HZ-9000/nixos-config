# NixOS installer

A minimal flake for the first install of [storm](../hosts/storm) and
[stormlight](../hosts/stormlight). It reuses the main flake's disk layout, hardware config,
preservation and base modules, but skips the desktop, agenix and lanzaboote.

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
2. Review `../hosts/<host>/hardware-configuration.nix` against the target machine; after
   the disk is mounted, regenerate it with `nixos-generate-config --root /mnt` if the hardware
   differs.

### 1. Partition and mount with disko

The layout is defined in [../hosts/storm/disko-fs.nix](../hosts/storm/disko-fs.nix): a 600 MiB ESP,
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

### 3. Copy data into /persistent and reboot

```bash
nixos-enter

# Copy/migrate into /persistent as needed (e.g. from an old disk).
# At minimum for a fresh install:
#   mkdir -p /persistent/etc
#   mv /etc/machine-id /persistent/etc/
#   mv /etc/ssh /persistent/etc/
exit

# Keep this checkout: / is tmpfs, so put it where preservation mounts ~/nixos-config from.
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

The login shell is nushell and these commands use bash syntax (`$(hostname)`), so run `bash`
first. `programs.ssh.startAgent` runs the agent; nushell gets `SSH_AUTH_SOCK` from the autoload
file in [../modules/nixos/base/ssh.nix](../modules/nixos/base/ssh.nix). On an install made
before that file existed, set it by hand in nushell with
`$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"`.

```bash
sudo chown -R hz-9000:users ~/nixos-config

# Generate a key named after the host (use a passphrase) and load it into the agent.
ssh-keygen -t ed25519 -a 256 -C "hz-9000@$(hostname)" -f ~/.ssh/$(hostname)
ssh-add ~/.ssh/$(hostname)

# Upload it with the gh CLI (installed by this flake). The admin:public_key scope
# is what lets gh add SSH keys; --skip-ssh-key stops gh offering to make its own.
# --web needs no local browser: gh prints a one-time code; enter it at
# https://github.com/login/device on your phone or another computer.
gh auth login --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key
gh ssh-key add ~/.ssh/$(hostname).pub --title "$(hostname)"

# `just switch` runs nixos-rebuild through sudo, so root fetches over your agent.
ssh -T git@github.com        # should greet you by username
sudo ssh -T git@github.com   # accept GitHub's host key for root
```

[../home/base/tui/ssh.nix](../home/base/tui/ssh.nix) sets `IdentitiesOnly` for `github.com`,
so the host's Home Manager file must name the key, as
[../home/hosts/linux/storm.nix](../home/hosts/linux/storm.nix) does:

```nix
programs.ssh.settings."github.com".IdentityFile = "~/.ssh/${hostName}";
```

To allow SSH logins into this machine with the key, add the `.pub` line to
`mainSshAuthorizedKeys` or `secondaryAuthorizedKeys` in [../vars/default.nix](../vars/default.nix).

### 2. Add the host to the agenix secrets

Hosts decrypt secrets with their SSH host key, `/persistent/etc/ssh/ssh_host_ed25519_key`,
which sshd creates on first boot. The new host can't decrypt anything until an existing host
re-encrypts the secrets for it. On a machine that can already decrypt (e.g. stormlight):

```bash
cd ~/nixos-config
just secrets-rekey storm     # fetches storm's key with ssh-keyscan and asks you to confirm
# or: just secrets-rekey storm "$(ssh storm cat /etc/ssh/ssh_host_ed25519_key.pub)"
git -C nixos-secrets push
```

Then, on the new host, `nix flake update nixos-secrets` before switching.

If no machine can decrypt (all hosts lost, no deploy key), run `just secrets-regen storm` on the
new host instead. It enters fresh passwords and a GitHub token, so every host's values change.

### 3. Deploy the main config

```bash
cd ~/nixos-config
just switch storm
```

### 4. Set up Secure Boot

[../hosts/common/secure-boot.nix](../hosts/common/secure-boot.nix) replaces
systemd-boot with [lanzaboote](https://github.com/nix-community/lanzaboote),
which signs the kernel and boot files with keys stored in `/var/lib/sbctl`. That
directory is preserved. Keep Secure Boot **disabled** in firmware until the end
of this step.

1. **Check that lanzaboote is active.** After the main config is deployed, it
   should be the bootloader:

    ```bash
    bootctl status   # "Product" should mention lanzaboote
    ```

2. **Create the signing keys.** They are local to this machine; never commit them.

    ```bash
    sudo sbctl create-keys
    ```

3. **Rebuild so lanzaboote signs everything with the new keys**, then confirm:

    ```bash
    just switch storm
    sudo sbctl verify   # every lanzaboote/kernel EFI file should be "signed"
    ```

    The unsigned `systemd-bootx64.efi` / `BOOTX64.EFI` files that lanzaboote
    doesn't use can be ignored.

4. **Put the firmware in Setup Mode.** Reboot into the firmware settings:
    - **storm** (MSI): Secure Boot → set mode to *Custom*, then delete or clear all
      Secure Boot keys.
    - **stormlight** (Framework): Secure Boot → *Erase all Secure Boot Settings*
      (puts it in Setup Mode).

    Save, boot back into NixOS, and confirm:

    ```bash
    sudo sbctl status   # "Setup Mode: Enabled"
    ```

5. **Enroll the keys.** `--microsoft` also enrolls Microsoft's certificates.
   Keep that flag: without it, firmware option ROMs (e.g. the GPU) may fail to load
   and the machine may not boot.

    ```bash
    sudo sbctl enroll-keys --microsoft
    ```

6. **Enable Secure Boot.** Reboot into the firmware, turn Secure Boot on, and boot
   NixOS. Then check:

    ```bash
    sudo sbctl status   # "Secure Boot: Enabled", "Setup Mode: Disabled"
    ```

7. **Re-enroll TPM unlocking.** Enabling Secure Boot changes PCR 7, so the LUKS
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
