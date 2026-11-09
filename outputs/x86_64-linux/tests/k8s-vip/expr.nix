# keepalived holds the API address on the masters only; the init master has
# the highest priority and every master peers with the other two.
{
  lib,
  k8sHosts,
  outputs,
}:
lib.genAttrs k8sHosts (
  name:
  let
    config = outputs.nixosConfigurations.${name}.config;
    instance = config.services.keepalived.vrrpInstances.k8s-api or null;
  in
  {
    keepalived = config.services.keepalived.enable;
    priority = instance.priority or null;
    peers = instance.unicastPeers or null;
    virtualIps = if instance == null then null else map (ip: ip.addr) instance.virtualIps;
  }
)
