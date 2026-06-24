{ config, ... }:
let
  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configDir = "${config.home.homeDirectory}/nixos-config/dotfiles";
in
{
  # Note: .config/hypr is intentionally NOT symlinked here.
  # home/linux/hyprland/config.nix generates ~/.config/hypr/hyprland.lua via
  # home-manager (configType = "lua"). Do not add dotfiles/hypr/hyprland.lua.
  home.file = {
    ".config/starship.toml".source = mkOutOfStoreSymlink "${configDir}/starship/starship.toml";
  };
}
