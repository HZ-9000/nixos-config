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

  # programs.ssh.startAgent exports SSH_AUTH_SOCK from environment.extraInit, which only
  # POSIX shells source. The login shell is nushell, so a TTY or SSH login (e.g. on a fresh
  # install) has no socket: `ssh-add` fails with "Could not open a connection to your
  # authentication agent". Nushell loads vendor autoload files from the system profile.
  environment.pathsToLink = lib.mkIf config.programs.ssh.startAgent [
    "/share/nushell/vendor/autoload"
  ];

  # Add terminfo entries for the terminals actually used in this flake.
  # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/config/terminfo.nix
  environment.systemPackages =
    map (x: x.terminfo) (
      with pkgs.pkgsBuildBuild;
      [
        ghostty
        kitty
      ]
    )
    ++ lib.optional config.programs.ssh.startAgent (
      pkgs.writeTextDir "share/nushell/vendor/autoload/ssh-agent.nu" ''
        if ($env.SSH_AUTH_SOCK? | is-empty) and ($env.XDG_RUNTIME_DIR? | is-not-empty) {
          $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"
        }
      ''
    );
}
