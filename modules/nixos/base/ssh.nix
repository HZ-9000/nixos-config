{ config, lib, pkgs, ... }:
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

  # GitHub's host key (https://api.github.com/meta), so neither the user (ssh.github.com:443,
  # see home/base/tui/ssh.nix) nor root (`sudo nixos-rebuild` fetching nixos-secrets) stops
  # at a trust-on-first-use prompt, and a spoofed key fails instead of being accepted.
  programs.ssh.knownHosts.github = {
    hostNames = [
      "github.com"
      "[ssh.github.com]:443"
    ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  # Load keys into the agent on first use. Home Manager sets this for the user too, but the
  # installer system has no Home Manager.
  programs.ssh.extraConfig = lib.mkIf config.programs.ssh.startAgent ''
    AddKeysToAgent yes
  '';

  # sudo resets the environment, so `sudo nixos-rebuild` (`just switch`) would fetch the
  # private nixos-secrets repo as root without the user's agent. Root can read the socket.
  security.sudo.extraConfig = lib.mkIf config.programs.ssh.startAgent ''
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  # Nushell gets SSH_AUTH_SOCK from modules/nixos/base/nushell.nix.

  # Add terminfo entries for the terminals actually used in this flake.
  # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/config/terminfo.nix
  environment.systemPackages =
    map (x: x.terminfo) (
      with pkgs.pkgsBuildBuild;
      [
        ghostty
        kitty
      ]
    );
}
