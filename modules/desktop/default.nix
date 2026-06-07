{ ... }:
{
  imports = [
    ./hyprland.nix
    ./display-manager.nix
    ./system.nix
    ./pipewire.nix
    ./program.nix
    ./network.nix
    ./services.nix
    ./user.nix
    # ./hyprlock.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./nh.nix
    ./zsh.nix
  ];
}
