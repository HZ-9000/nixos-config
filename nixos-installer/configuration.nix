{ pkgs, myvars, ... }:
let
  # No agenix here: the host's age identity doesn't exist yet on a fresh install.
  # Both accounts read a hash written by hand during install (/ is tmpfs, so it
  # has to live under /persistent). The agenix-managed passwords take over on the
  # first switch to the main config.
  passwordFile = "/persistent/etc/installer-password";
in
{
  users.users.root.hashedPasswordFile = passwordFile;
  users.users.${myvars.username}.hashedPasswordFile = passwordFile;

  # ssh-agent is used to pull my private secrets repo from github when deploying my nixos config.
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    gh # generate and upload the host's GitHub SSH key
    sbctl # create the Secure Boot keys lanzaboote needs on the first switch to the main config
    just
    curl
    wget
    nix-output-monitor
  ];

  # configures the network interface(include wireless) via `nmcli` & `nmtui`
  networking.networkmanager.enable = true;

  system.stateVersion = "26.05";
}
