{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # configurationLimit is already set in modules/nixos/base/core.nix
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
