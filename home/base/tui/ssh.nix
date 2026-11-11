{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "yes";
        Compression = true;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
        IdentitiesOnly = true;
      };
    }
    # k8s nodes by name or address (colmena and `just k8s-switch` use the address), as root
    # like the deploys. A shared master per node makes colmena's many ssh calls reuse one
    # connection; the keepalive reaps a master whose VM went away.
    // lib.mapAttrs' (
      name: node:
      lib.nameValuePair "${name} ${node.address}" {
        HostName = node.address;
        User = "root";
        ControlMaster = "auto";
        ControlPersist = "10m";
        ServerAliveInterval = 15;
      }
    ) myvars.k8s.nodes;
  };
}
