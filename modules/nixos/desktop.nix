{ ... }:
{
  imports = [
    ./base # modules/nixos/base/ — core NixOS settings (bootloader, i18n, ssh, users)
    ../base # modules/base/ — shared base (fonts, hardware, nix cachix, user account)
    ./desktop # modules/nixos/desktop/ — full desktop environment (Hyprland, audio, etc.)
  ];
}
