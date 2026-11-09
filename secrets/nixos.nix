# Opt-in: imported by hosts that decrypt secrets (see outputs/x86_64-linux/src/).
{
  inputs,
  agenix,
  pkgs,
  config,
  myvars,
  ...
}:
{
  imports = [ agenix.nixosModules.default ];

  # Decrypt with the SSH host key (its public half is the host's recipient in
  # nixos-secrets/secrets.nix). Read it from /persistent directly: with systemd initrd,
  # activation (and agenix) runs before preservation bind-mounts /etc/ssh.
  age.identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];

  # agenix orders its own activation script before the users activation script
  # (system.activationScripts.users.deps), so these are decrypted in time for
  # hashedPasswordFile — no sops-nix-style `neededForUsers` flag needed here.
  age.secrets.user-password.file = "${inputs.nixos-secrets}/user-password.age";
  age.secrets.root-password.file = "${inputs.nixos-secrets}/root-password.age";

  # Kept here rather than in user-group.nix so the installer flake
  # (nixos-installer/flake.nix) and the k8s nodes, which have no agenix, can reuse that module.
  users.users.${myvars.username}.hashedPasswordFile = config.age.secrets.user-password.path;
  users.users.root.hashedPasswordFile = config.age.secrets.root-password.path;

  # `age`, e.g. to test decryption: sudo age -d -i /persistent/etc/ssh/ssh_host_ed25519_key <file>
  environment.systemPackages = [ pkgs.age ];
}
