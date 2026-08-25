{ ... }:
{
  imports = [
    ../common/default.nix
    ./browser.nix
    ./gtk.nix
    ./nemo.nix
    ./xdg-mimes.nix
    ./niri
    ./vicinae
    ./noctalia
    ./packages
  ];
}
