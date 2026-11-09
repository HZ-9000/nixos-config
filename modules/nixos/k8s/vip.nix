# Floating API server address (myvars.k8s.apiEndpoint) shared by the masters
# via keepalived/VRRP. Every master runs the same instance; the one with the
# highest priority whose local API server answers holds the address. Works
# before the cluster exists: at bootstrap only the init master runs k3s.
{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  cfg = config.modules.k8s;
  cluster = myvars.k8s;

  masters = lib.sort lib.lessThan (
    builtins.attrNames (lib.filterAttrs (_: n: n.role == "master") cluster.nodes)
  );
  # Init master first (150), then 140, 130, ... A failing health check
  # subtracts 50, so any healthy master outranks an unhealthy one.
  ordered = [ cluster.initNode ] ++ lib.remove cluster.initNode masters;
  index = lib.lists.findFirstIndex (n: n == config.networking.hostName) 0 ordered;
  peers = map (n: cluster.nodes.${n}.address) (lib.remove config.networking.hostName masters);
in
lib.mkIf (cfg.role == "master") {
  services.keepalived = {
    enable = true;
    openFirewall = true; # VRRP and AH
    vrrpScripts.k3s-api = {
      # Healthy when the local API server accepts TCP connections. (k3s turns
      # off anonymous auth, so an HTTP /livez probe would get 401.)
      script = toString (pkgs.writeShellScript "k3s-api-check" "exec 3<>/dev/tcp/127.0.0.1/6443");
      interval = 2;
      fall = 2;
      rise = 2;
      weight = -50;
      user = "keepalived_script";
      group = "keepalived_script";
    };
    vrrpInstances.k8s-api = {
      interface = cluster.network.interface;
      state = "BACKUP"; # let priority decide who becomes MASTER
      virtualRouterId = cluster.vip.routerId;
      priority = 150 - 10 * index;
      # Unicast: no reliance on multicast across the Proxmox bridge.
      unicastSrcIp = cfg.address;
      unicastPeers = peers;
      virtualIps = [ { addr = "${cluster.apiEndpoint}/${toString cluster.network.prefixLength}"; } ];
      trackScripts = [ "k3s-api" ];
    };
  };

  # The NixOS module doesn't create the script user.
  users.users.keepalived_script = {
    isSystemUser = true;
    group = "keepalived_script";
  };
  users.groups.keepalived_script = { };
}
