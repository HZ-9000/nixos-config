{ ... }:
{
  imports = [
    ./hyprland.nix
    # display-manager.nix removed — covered by modules/base/xserver.nix
    ./system.nix
    ./pipewire.nix
    ./program.nix
    ./network.nix
    ./services.nix
    ./user.nix
    ./hyprlock.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./nh.nix
    # zsh.nix removed — programs.zsh.enable is in program.nix
    ./xdg.nix
  ];
}
