{ lib, pkgs, ... }:
{
  # Secure by default: firewall ON everywhere unless a host explicitly disables it.
  networking.firewall.enable = lib.mkDefault true;
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = lib.mkDefault false;
      # root user is used for remote deployment, so we need to allow it
      PermitRootLogin = lib.mkDefault "prohibit-password";
      PasswordAuthentication = lib.mkDefault false; # disable password login
    };
    # Don't open port 22 on every interface; tailscale0 is a trusted interface
    # (modules/nixos/desktop/networking/firewall.nix), so SSH works over the tailnet.
    openFirewall = lib.mkDefault false;
  };

  # Add terminfo entries for the terminals actually used in this flake.
  # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/config/terminfo.nix
  environment.systemPackages = map (x: x.terminfo) (with pkgs.pkgsBuildBuild; [ ghostty kitty ]);
}
