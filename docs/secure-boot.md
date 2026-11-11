# Secure Boot

Secure Boot is opt-in. [../modules/nixos/base/secure-boot.nix](../modules/nixos/base/secure-boot.nix)
replaces systemd-boot with [lanzaboote](https://github.com/nix-community/lanzaboote), which signs
the kernel and boot files with keys stored in `/var/lib/sbctl`. A host turns it on in
`hosts/<host>/default.nix`:

```nix
modules.secureBoot.enable = true;
```

storm and stormlight have it on. The [installer flake](../nixos-installer/README.md) always
installs with systemd-boot, because the keys can only be created once the machine runs.

The keys are local to each machine; never commit them. Every host with preservation keeps
`/var/lib/sbctl` (see [../hosts/common/preservation.nix](../hosts/common/preservation.nix)), so they
survive reboots. The steps use `storm`; substitute the host. Keep Secure Boot **disabled** in
firmware until step 3 says to turn it on.

## 1. Create the signing keys

Lanzaboote won't install unsigned files, so the first switch with Secure Boot enabled fails at
the bootloader step unless the keys exist. Create them first; `sbctl` is installed by the
installer flake and by the module itself.

```bash
sudo sbctl create-keys
```

## 2. Switch

```bash
just switch storm
```

If it fails while installing the bootloader, check that `sudo sbctl status` shows the keys as
installed, then switch again.

## 3. Enroll the keys and turn Secure Boot on

1. **Check that lanzaboote is active.** After that switch it should be the bootloader:

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
