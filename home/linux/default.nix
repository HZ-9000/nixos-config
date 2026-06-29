{ ... }:
{
  imports = [
    ./browser.nix
    ./git.nix
    ./gtk.nix
    ./nemo.nix
    ./sops.nix
    ./theme.nix
    ./xdg-mimes.nix
    ./niri
    ./packages
    ./noctalia
    ./vicinae
    ./nushell
  ];
}
