# NixOS installer flake

This flake exposes minimal installer configurations for `storm`, `stormlight`,
and `parallels`. It reuses the repository's shared base modules and host
hardware/storage definitions without importing the desktop or Home Manager
stacks.

Evaluate a target before installation:

```bash
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

Storm and Stormlight also include the shared preservation, btrbk, and
Lanzaboote modules. Create and enroll their `/var/lib/sbctl` keys as documented
in the root README before enabling Secure Boot in firmware.
