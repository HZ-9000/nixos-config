{ ... }:
{
  modules.desktop.fonts.enable = true;

  imports = [
    ./niri.nix
    ./vicinae.nix
    ./system.nix
    ./pipewire.nix
    ./program.nix
    ./network.nix
    ./services.nix
    ./user.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./nh.nix
    ./xdg.nix
  ];
}
