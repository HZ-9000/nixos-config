# NixOS installer flake

This flake installs NixOS on a target system.

## Why this flake exists

The main flake is heavy and slow to deploy. This minimal flake helps to:

1. Adjust and verify `hardware-configuration.nix` and disk layout before deploying the main flake.
2. Test preservation, Secure Boot, TPM 2.0, and encryption on a fresh install.

Disk layout is **declarative** via [disko](https://github.com/nix-community/disko); manual
partitioning is no longer needed.

## Deployment Steps

These steps set up storm, a desktop with a Ryzen CPU and GPU.

1. Create a USB install medium from the official NixOS ISO and boot from it.

### 1. Partition and mount with disko (recommended)

The layout is defined in [../hosts/storm/disko-fs.nix](../hosts/storm/disko-fs.nix): a 600 MiB ESP,
LUKS, and Btrfs subvolumes (`@nix`, `@guix`, `@persistent`, `@snapshots`, `@tmp`, and `@swap`). The
root filesystem is tmpfs; [preservation](https://github.com/nix-community/preservation) uses `/persistent`.

```bash
git clone https://github.com/HZ-9000/nixos-config.git
cd nixos-config/nixos-installer

sudo su

# Encrypt the root partition with LUKS2 and Argon2id. You will be prompted for a passphrase to unlock it.
# WARNING: destroys all data on nvme0n1. Layout is mounted at /mnt by default.
nix run github:nix-community/disko -- --mode destroy,format,mount ../hosts/storm/disko-fs.nix

# Mount only (e.g. after first format, without wiping):
# nix run github:nix-community/disko -- --mode mount ../hosts/storm/disko-fs.nix

# Set up automatic unlocking with the TPM 2.0 chip.
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/<encrypted-disk-part-path>
```

### 2. Install NixOS

```bash
sudo su

# From nixos-config/nixos-installer
nixos-install --root /mnt --flake .#storm --no-root-password
```

### 3. Copy data into /persistent and reboot

Preservation expects state under `/persistent`; copy or migrate data there (e.g. from an old disk),
then leave the chroot and reboot.

```bash
nixos-enter

# Copy/migrate into /persistent as needed (e.g. from old nvme0n1)
# At minimum for a fresh install:
#   mkdir -p /persistent/etc
#   mv /etc/machine-id /persistent/etc/
#   mv /etc/ssh /persistent/etc/
# Then exit and:
exit
umount -R /mnt
reboot
```

## Deploying the Main Flake After Installation

After the first boot:

1. Deploy the main config:

    ```bash
    cd ..
    just switch storm
    ```

2. **Secure Boot**: follow
    [lanzaboote Quick Start](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)
    and [hosts/storm/secure-boot.nix](../hosts/storm/secure-boot.nix).

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
