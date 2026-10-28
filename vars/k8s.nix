# Kubernetes (k3s) cluster running as Proxmox VMs. Consumed by
# outputs/x86_64-linux/src/k8s.nix (one nixosConfiguration per node) and
# modules/nixos/k8s/ (role, networking, k3s settings).
#
# NOTE: the addresses below are PLACEHOLDERS. Set them to match your Proxmox
# network (and DHCP reservations) before deploying.
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

  # Address workers and the other masters use to reach the API server. Points
  # at the init master for now; swap in a virtual IP (kube-vip / keepalived)
  # or a DNS name once one exists, and it also becomes an API server TLS SAN.
  apiEndpoint = "192.168.6.32";

  network = {
    prefixLength = 24;
    gateway = "192.168.6.1";
    nameservers = [
      "192.168.1.1"
    ];
  };

  # Block device of the VM's system disk, as seen inside the guest (the first
  # virtio-scsi disk, `scsi0`, in Proxmox).
  diskDevice = "/dev/sda";

  # Root-only file on every node holding the shared k3s cluster token. It is
  # not in the Nix store: copy it in at install time (see hosts/k8s/README.md).
  tokenFile = "/etc/k3s/token";
}
