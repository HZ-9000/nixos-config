{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    dive # explore docker layers
    lazydocker # Docker terminal UI.

    kubectl
    kubernetes-helm
  ];

  programs = {
    k9s = {
      enable = true;
    };
  };
}
