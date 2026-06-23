{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = "*";
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
