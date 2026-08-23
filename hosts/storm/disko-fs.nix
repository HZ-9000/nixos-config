# Declarative disk layout – mirrors the parted/mkfs steps in the repo Justfile.
# Adjust `device` if the NVMe enumeration differs on the target machine.
{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            root = {
              # Leave 8 GiB at the end for swap, matching the Justfile layout.
              end = "-8G";
              content = {
                type = "filesystem";
                format = "tmpfs";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos" ];
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
  };
}
