{
  config,
  lib,
  myvars,
  ...
}:
let
  cfg = config.modules.k8s;
  cluster = myvars.k8s;
  isMaster = cfg.role == "master";
  isInit = config.networking.hostName == cluster.initNode;
  initAddress = cluster.nodes.${cluster.initNode}.address;
in
{
  services.k3s = {
    enable = true;
    role = if isMaster then "server" else "agent";
    tokenFile = cluster.tokenFile;

    # HA: the init master bootstraps embedded etcd, every other server and
    # every agent joins an existing master.
    clusterInit = isMaster && isInit;
    serverAddr =
      if isInit then
        ""
      else if isMaster then
        "https://${initAddress}:6443"
      else
        "https://${cluster.apiEndpoint}:6443";

    extraFlags =
      lib.optionals isMaster [
        "--tls-san=${cluster.apiEndpoint}"
        # Keep workloads on the workers.
        "--node-taint=node-role.kubernetes.io/control-plane=true:NoSchedule"
      ]
      ++ [ "--node-ip=${cfg.address}" ];

    gracefulNodeShutdown.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      10250 # kubelet
    ]
    ++ lib.optionals isMaster [
      6443 # API server
      2379 # etcd client
      2380 # etcd peer
    ];
    allowedUDPPorts = [
      8472 # flannel vxlan
    ];
  };
}
