{ inputs, pkgs, ... }:
{
  # Read the key from /persistent directly: with systemd initrd, activation (and
  # agenix) runs before preservation bind-mounts /etc/age.
  age.identityPaths = [ "/persistent/etc/age/keys.txt" ];

  # agenix orders its own activation script before the users activation script
  # (system.activationScripts.users.deps), so these are decrypted in time for
  # hashedPasswordFile — no sops-nix-style `neededForUsers` flag needed here.
  age.secrets.user-password.file = "${inputs.nixos-secrets}/user-password.age";
  age.secrets.root-password.file = "${inputs.nixos-secrets}/root-password.age";

  # `age-keygen` (and `age`), e.g. to print the public key of the host identity:
  #   sudo age-keygen -y /persistent/etc/age/keys.txt
  environment.systemPackages = [ pkgs.age ];
}
