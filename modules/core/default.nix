{ ... }:
{
  imports = [
    ./bootloader.nix
    ./system.nix
    ./user.nix
    ./hardware.nix
    ./wayland.nix
  ];
}
