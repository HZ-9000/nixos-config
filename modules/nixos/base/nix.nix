{ lib, ... }:
{
  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  # nix.package = pkgs.nixVersions.latest;

  # https://lix.systems/add-to-config/
  # nix.package = pkgs.lix;

  # to install chrome, you need to enable unfree packages
  nixpkgs.config.allowUnfree = lib.mkForce true;

  nix = {
    # Do garbage collection weekly to keep disk usage low.
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # Manual optimise storage: nix-store --optimise
    settings.auto-optimise-store = true;

    # Remove nix-channel tools and configuration; this repository uses flakes.
    channel.enable = false;
  };
}
