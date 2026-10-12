# Desktops hold personal data and laptops join untrusted networks, so enable the
# firewall explicitly here rather than relying on the mkDefault in modules/nixos/base/ssh.nix.
# SSH/Tailscale keep working via their own `openFirewall` options.
{
  networking.firewall = {
    enable = true;
    # Trust everything from the tailnet.
    trustedInterfaces = [ "tailscale0" ];
  };
}
