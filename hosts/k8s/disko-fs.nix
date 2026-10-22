# Plain GPT + ext4 on the VM's single system disk. No LUKS/tmpfs-root here:
# the nodes must boot unattended and k3s keeps its state under /var/lib.
{ myvars, ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = myvars.k8s.diskDevice;
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
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
}
