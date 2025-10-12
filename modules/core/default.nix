{ ... }:
{
  imports = [
    ./bootloader.nix
    ./system.nix
    ./pipewire.nix
    ./user.nix
    ./network.nix
    ./hardware.nix
    ./services.nix
    ./xserver.nix
    ./wayland.nix
  ];
}
