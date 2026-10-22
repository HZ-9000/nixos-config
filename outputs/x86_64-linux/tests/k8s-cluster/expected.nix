let
  master = {
    role = "master";
    k3sRole = "server";
    homeManager = false;
  };
  worker = {
    role = "worker";
    k3sRole = "agent";
    clusterInit = false;
    homeManager = false;
  };
in
{
  k8s-master-1 = master // {
    hostName = "k8s-master-1";
    clusterInit = true;
  };
  k8s-master-2 = master // {
    hostName = "k8s-master-2";
    clusterInit = false;
  };
  k8s-master-3 = master // {
    hostName = "k8s-master-3";
    clusterInit = false;
  };
  k8s-worker-1 = worker // {
    hostName = "k8s-worker-1";
  };
  k8s-worker-2 = worker // {
    hostName = "k8s-worker-2";
  };
  k8s-worker-3 = worker // {
    hostName = "k8s-worker-3";
  };
}
