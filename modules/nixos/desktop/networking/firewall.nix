# Desktops hold personal data and laptops join untrusted networks, so enable the
# firewall explicitly here rather than relying on the mkDefault in modules/nixos/base/ssh.nix.
# Tailscale opens its own port via `openFirewall`; SSH is only reachable over the tailnet.
{
  networking.firewall = {
    enable = true;
    # Trust everything from the tailnet.
    trustedInterfaces = [ "tailscale0" ];
  };
}
