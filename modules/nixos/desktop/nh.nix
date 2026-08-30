{ pkgs, myvars, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${myvars.username}/${myvars.configDirectoryName}";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
