# Also used directly by the disko CLI during install (nixos-installer/README.md).
import ../common/disko-fs.nix {
  name = "nixos-stormlight";
  device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_1TB_S7U5NJ0Y798106N";
}
