{ inputs, myvars, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.nixos-secrets}/secrets.yaml";
    age.keyFile = "/etc/age/keys.txt";
  };

  # Home-manager sops decrypts as the desktop user, so the host age key must
  # be group-readable. Keep the directory executable so that path is reachable.
  systemd.tmpfiles.settings.sops-age-key = {
    "/etc/age".d = {
      user = "root";
      group = "root";
      mode = "0751";
    };
    "/etc/age/keys.txt".z = {
      user = "root";
      group = myvars.username;
      mode = "0640";
    };
  };
}
