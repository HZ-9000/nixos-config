{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # digitalocean
    doctl
    # google cloud
    google-cloud-sdk

    # cloud tools that nix do not have cache for.
    terraform
  ];
}
