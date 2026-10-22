# Proxmox / QEMU guest, UEFI (OVMF) firmware.
{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "virtio_blk"
      "sd_mod"
      "sr_mod"
      "ahci"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      # The OVMF efidisk can be lost or recreated; systemd-boot also installs
      # the removable fallback path, so don't depend on an NVRAM boot entry.
      efi.canTouchEfiVariables = false;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
