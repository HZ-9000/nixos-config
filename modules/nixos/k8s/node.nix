{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.modules.k8s;
  keys = myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys;
in
{
  options.modules.k8s = {
    role = mkOption {
      type = types.enum [
        "master"
        "worker"
      ];
      description = "Whether this node is a k3s server (control plane + etcd) or agent.";
    };
    address = mkOption {
      type = types.str;
      description = "Static IPv4 address of this node.";
    };
  };

  config = {
    assertions = [
      {
        assertion = keys != [ ];
        message = ''
          vars/default.nix: mainSshAuthorizedKeys is empty. The k8s nodes have no
          password login, so without an SSH key you could not reach them.
        '';
      }
    ];

    networking = {
      useDHCP = false;
      useNetworkd = true;
      networkmanager.enable = false;
    };
    systemd.network.networks."10-lan" = {
      # Proxmox virtio NICs are ens18, ens19, ...; CNI/flannel interfaces don't match.
      matchConfig.Name = "en*";
      address = [ "${cfg.address}/${toString myvars.k8s.network.prefixLength}" ];
      gateway = [ myvars.k8s.network.gateway ];
      dns = myvars.k8s.network.nameservers;
    };

    # Reachable on the LAN (unlike desktops, where ssh is tailnet-only).
    services.openssh.openFirewall = true;

    # Lets Proxmox show the guest's IPs and shut it down cleanly.
    services.qemuGuest.enable = true;

    users = {
      mutableUsers = false;
      users = {
        ${myvars.username} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = keys;
        };
        # Used for remote deployment (nixos-anywhere / nixos-rebuild --target-host).
        root.openssh.authorizedKeys.keys = keys;
      };
    };
    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [ myvars.username ];

    environment.systemPackages = with pkgs; [
      git
      helix
      htop
    ];

    # Servers are headless; keep the closure small.
    documentation.enable = false;
  };
}
