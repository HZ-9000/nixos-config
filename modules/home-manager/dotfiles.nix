{ config, ... }:

let
  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configDir = "${config.home.homeDirectory}/nixos-config/dotfiles";
in
{
  home.file = {
    ".config/hypr".source = mkOutOfStoreSymlink "${configDir}/hypr";
    ".config/starship.toml".source = mkOutOfStoreSymlink "${configDir}/starship/starship.toml";
  };
}