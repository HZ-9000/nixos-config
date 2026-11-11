{ osConfig, ... }:
{
  imports = [
    ../base
    ./gui
  ];

  # Each host's key is named after it (nixos-installer/README.md), which isn't one of ssh's
  # default ~/.ssh/id_* names. Offer it everywhere: GitHub (IdentitiesOnly in
  # home/base/tui/ssh.nix) and the other machines, even before it is in the agent.
  programs.ssh.settings."*".IdentityFile = "~/.ssh/${osConfig.networking.hostName}";
}
