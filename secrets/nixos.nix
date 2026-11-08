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

  # Read the key from /persistent directly: with systemd initrd, activation (and
  # agenix) runs before preservation bind-mounts /etc/age.
  age.identityPaths = [ "/persistent/etc/age/keys.txt" ];

  # agenix orders its own activation script before the users activation script
  # (system.activationScripts.users.deps), so these are decrypted in time for
  # hashedPasswordFile — no sops-nix-style `neededForUsers` flag needed here.
  age.secrets.user-password.file = "${inputs.nixos-secrets}/user-password.age";
  age.secrets.root-password.file = "${inputs.nixos-secrets}/root-password.age";

  # Kept here rather than in user-group.nix so the installer flake
  # (nixos-installer/flake.nix) and the k8s nodes, which have no agenix, can reuse that module.
  users.users.${myvars.username}.hashedPasswordFile = config.age.secrets.user-password.path;
  users.users.root.hashedPasswordFile = config.age.secrets.root-password.path;

  # `age-keygen` (and `age`), e.g. to print the public key of the host identity:
  #   sudo age-keygen -y /persistent/etc/age/keys.txt
  environment.systemPackages = [ pkgs.age ];
}
