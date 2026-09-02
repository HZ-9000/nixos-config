{ config, inputs, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.nixos-secrets}/secrets.yaml";
    secrets.gh-token = { };

    templates.gh-config.content = ''
      hosts:
        github.com:
          oauth_token: ${config.sops.placeholder.gh-token}
    '';
  };

  home.file.".config/gh/hosts.yml".source =
    config.lib.file.mkOutOfStoreSymlink config.sops.templates.gh-config.path;
}
