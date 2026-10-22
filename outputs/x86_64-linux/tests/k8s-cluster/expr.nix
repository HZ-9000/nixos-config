{
  lib,
  k8sHosts,
  outputs,
}:
lib.genAttrs k8sHosts (
  name:
  let
    config = outputs.nixosConfigurations.${name}.config;
  in
  {
    hostName = config.networking.hostName;
    role = config.modules.k8s.role;
    k3sRole = config.services.k3s.role;
    clusterInit = config.services.k3s.clusterInit;
    homeManager = config ? home-manager;
  }
)
