{ ... }:
{
  imports = [
    ./bootloader.nix
    ./system.nix
    ./pipewire.nix
    ./nh.nix
    ./user.nix
    ./network.nix
    ./hardware.nix
    ./services.nix
    ./xserver.nix
    ./wayland.nix
    ./program.nix
  ];
}
