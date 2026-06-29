{ ... }:
{
  imports = [
    ./git.nix
    ./theme.nix
    ./nushell
    ./programs/ghostty.nix
    ./programs/nvim.nix
    ./programs/btop.nix
    ./packages
  ];
}
