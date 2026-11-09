let
  vip = [ "192.168.6.32/24" ];
  worker = {
    keepalived = false;
    priority = null;
    peers = null;
    virtualIps = null;
  };
in
{
  k8s-master-1 = {
    keepalived = true;
    priority = 150;
    peers = [
      "192.168.6.12"
      "192.168.6.13"
    ];
    virtualIps = vip;
  };
  k8s-master-2 = {
    keepalived = true;
    priority = 140;
    peers = [
      "192.168.6.11"
      "192.168.6.13"
    ];
    virtualIps = vip;
  };
  k8s-master-3 = {
    keepalived = true;
    priority = 130;
    peers = [
      "192.168.6.11"
      "192.168.6.12"
    ];
    virtualIps = vip;
  };
  k8s-worker-1 = worker;
  k8s-worker-2 = worker;
  k8s-worker-3 = worker;
}
