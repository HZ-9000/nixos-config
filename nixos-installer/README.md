# NixOS installer bootstrap

This flake provides a small, network-enabled installation system for bootstrapping
`storm` and `stormlight`. It formats the target drive with the host's Disko
configuration, installs the bootstrap system, then lets the installed machine
switch to the full flake after its age key and encrypted secrets are available.

> [!WARNING]
> Disko destroys the disk specified by the selected host's
> `hosts/<hostname>/disko-fs.nix`. Verify the target device before continuing.

## Install the bootstrap system

1. Boot the NixOS installation media, connect to the network, and become root.
2. Verify the target disk with `lsblk`. If needed, update the host's
   `disko-fs.nix` device path before formatting.
3. Clone this repository outside `/mnt` and enter the installer flake:

   ```bash
   git clone https://github.com/HZ-9000/nixos-config.git /tmp/nixos-config
   cd /tmp/nixos-config/nixos-installer
   ```

4. Replace `<hostname>` with `storm` or `stormlight`, then format and mount the
   drive:

   ```bash
   nix run github:nix-community/disko -- --mode disko --flake .#<hostname>
   ```

5. Copy the flake into the mounted target, install it, and reboot:

   ```bash
   mkdir -p /mnt/etc/nixos
   mv /tmp/nixos-config /mnt/etc/nixos/nixos-config
   nixos-install --flake /mnt/etc/nixos/nixos-config/nixos-installer#<hostname>
   reboot
   ```

## Inject secrets and switch to the full configuration

After booting the installed system, clone the private secrets repository beside
the main configuration. Copy the matching pre-generated private key,
`nixos-secrets/keys/<hostname>.age`, into `/etc/age/keys.txt`; its public
counterpart must already be present as
`nixos-secrets/keys/<hostname>.age.pub`. Run the following as the installed
user with `sudo` access:

```bash
cd /etc/nixos/nixos-config
git clone git@github.com:HZ-9000/nixos-secrets.git
sudo install -d -m 700 /etc/age
sudo install -m 600 nixos-secrets/keys/<hostname>.age /etc/age/keys.txt
```

Apply the full configuration using the local secrets checkout:

```bash
sudo nixos-rebuild switch --flake .#<hostname> \
  --override-input nixos-secrets path:/etc/nixos/nixos-config/nixos-secrets
```

If the host does not yet have a matching age key, follow the key-generation and
recipient-update process in the [hosts README](../hosts/README.md#age-key-bootstrap-nixos)
before the final rebuild.