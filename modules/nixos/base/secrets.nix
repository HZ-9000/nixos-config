{ inputs, ... }:
{
  age.identityPaths = [ "/etc/age/keys.txt" ];

  # agenix orders its own activation script before the users activation script
  # (system.activationScripts.users.deps), so these are decrypted in time for
  # hashedPasswordFile — no sops-nix-style `neededForUsers` flag needed here.
  age.secrets.user-password.file = "${inputs.nixos-secrets}/user-password.age";
  age.secrets.root-password.file = "${inputs.nixos-secrets}/root-password.age";
}
