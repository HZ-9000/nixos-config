{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.nixos-secrets}/secrets.yaml";
    age.keyFile = "/etc/age/keys.txt";

    secrets.gh-token = { };

    templates.gh-config = {
      content = ''
        hosts:
          github.com:
            oauth_token: ${config.sops.placeholder.gh-token}
      '';
    };
  };

  home.file.".config/gh/hosts.yml".source = config.sops.templates.gh-config.path;
}
