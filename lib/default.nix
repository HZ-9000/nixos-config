{ lib, ... }:
{
  # Helper to build a NixOS system with optional home-manager
  nixosSystem = import ./nixosSystem.nix;

  # Helper to build a nix-darwin system with optional home-manager
  darwinSystem = import ./darwinSystem.nix;

  # Use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  # Scan a path and return all .nix files and subdirectories (excluding default.nix)
  scanPaths =
    path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
            (_type == "directory")
            || (
              (path != "default.nix")
              && (lib.strings.hasSuffix ".nix" path)
            )
        ) (builtins.readDir path)
      )
    );
}
