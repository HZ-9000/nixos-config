{ inputs, pkgs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services.displayManager.defaultSession = "niri";

  # System-wide Wayland env vars (string "1", not integer)
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Only system-level Niri ecosystem packages.
  # User-session tools (grim, slurp, cliphist, noctalia, etc.) are in home/linux.
  environment.systemPackages = with pkgs; [
    kitty # fallback terminal
    wlsunset
    wl-kbptr
    wtype
    xclip
  ];
}
