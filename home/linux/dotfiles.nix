{ config, ... }:
let
  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configDir = "${config.home.homeDirectory}/nixos-config/dotfiles";
in
{
  # Note: .config/hypr is intentionally NOT symlinked here.
  # wayland.windowManager.hyprland.settings in home/linux/hyprland/config.nix
  # already writes ~/.config/hypr/hyprland.conf via home-manager — having a
  # directory symlink there too would conflict with it.
  home.file = {
    ".config/starship.toml".source = mkOutOfStoreSymlink "${configDir}/starship/starship.toml";
  };
}
