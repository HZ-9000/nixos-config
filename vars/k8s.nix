# Kubernetes (k3s) cluster running as Proxmox VMs. Consumed by
# outputs/x86_64-linux/src/k8s.nix (one nixosConfiguration per node) and
# modules/nixos/k8s/ (role, networking, k3s settings).
#
# Check every address below against your Proxmox network (and keep them out of
# the DHCP range) before deploying.
let
  nodes = {
    k8s-master-1 = {
      role = "master";
      address = "192.168.6.11";
    };
    k8s-master-2 = {
      role = "master";
      address = "192.168.6.12";
    };
    k8s-master-3 = {
      role = "master";
      address = "192.168.6.13";
    };
    k8s-worker-1 = {
      role = "worker";
      address = "192.168.6.21";
    };
    k8s-worker-2 = {
      role = "worker";
      address = "192.168.6.22";
    };
    k8s-worker-3 = {
      role = "worker";
      address = "192.168.6.23";
    };
  };

  # The master that runs `k3s --cluster-init` (creates the embedded etcd
  # cluster). The other masters join it; it must be deployed first.
  initNode = "k8s-master-1";
in
{
  inherit nodes initNode;

  # Floating API server address held by one master at a time via keepalived
  # (modules/nixos/k8s/vip.nix). Workers join through it; it is also a TLS SAN.
  # Must be an unused address on the node subnet.
  apiEndpoint = "192.168.6.32";

  vip = {
    # VRRP router ID (1-255); must be unique among VRRP users on this LAN.
    routerId = 51;
  };

  # Addresses MetalLB hands out to LoadBalancer services (traefik gets the
  # first). Must be unused and outside the DHCP range.
  loadBalancerRange = "192.168.6.200-192.168.6.220";

  network = {
    # Proxmox's first virtio NIC; keepalived binds the API address to it.
    interface = "ens18";
    prefixLength = 24;
    gateway = "192.168.6.1";
    nameservers = [
      "192.168.1.1"
    ];
  };

  # Block device of the VM's system disk, as seen inside the guest (the first
  # virtio-scsi disk, `scsi0`, in Proxmox).
  diskDevice = "/dev/sda";
}
