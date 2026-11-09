# MetalLB in L2 mode instead of k3s's built-in servicelb: LoadBalancer
# services (including k3s's bundled traefik) get a real LAN address from
# myvars.k8s.loadBalancerRange, answered via ARP by whichever node runs them.
#
# Deployed by k3s's helm controller from the servers' auto-deploy manifests.
{
  config,
  lib,
  myvars,
  ...
}:
let
  isMaster = config.modules.k8s.role == "master";
in
{
  services.k3s = {
    disable = [ "servicelb" ];

    autoDeployCharts.metallb = lib.mkIf isMaster {
      repo = "https://metallb.github.io/metallb";
      name = "metallb";
      version = "0.16.2";
      hash = "";
      targetNamespace = "metallb-system";
      createNamespace = true;
      # Applied with the chart; k3s retries them until MetalLB's CRDs exist.
      extraDeploy = [
        {
          apiVersion = "metallb.io/v1beta1";
          kind = "IPAddressPool";
          metadata = {
            name = "lan";
            namespace = "metallb-system";
          };
          spec.addresses = [ myvars.k8s.loadBalancerRange ];
        }
        {
          apiVersion = "metallb.io/v1beta1";
          kind = "L2Advertisement";
          metadata = {
            name = "lan";
            namespace = "metallb-system";
          };
          spec.ipAddressPools = [ "lan" ];
        }
      ];
    };
  };

  # memberlist, used by the MetalLB speakers to agree on which node announces an IP.
  networking.firewall = {
    allowedTCPPorts = [ 7946 ];
    allowedUDPPorts = [ 7946 ];
  };
}
