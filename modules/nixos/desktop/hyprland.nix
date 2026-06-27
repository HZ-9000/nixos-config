{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
    # xdg-desktop-portal-hyprland is registered via programs.hyprland.portalPackage above
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # System-wide Wayland env vars (string "1", not integer)
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Only system-level Hyprland ecosystem packages.
  # User-session tools (grim, slurp, awww, cliphist, wl-clipboard, waybar,
  # swaynotificationcenter, hyprpicker) are in home/linux — no duplication.
  environment.systemPackages = with pkgs; [
    hyprutils
    hyprwayland-scanner
    hypridle
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    kitty # fallback terminal
    wofi
    wlsunset
    wl-kbptr
    wtype
    xclip
  ];
}
