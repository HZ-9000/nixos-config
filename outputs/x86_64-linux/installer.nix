# Minimal first-install systems, built from the same locked inputs as the real
# hosts so disko/preservation/nixpkgs can't drift between install and switch.
# Exposed as `installerConfigurations` (not nixosConfigurations) so the eval
# tests and `just` recipes that enumerate real hosts don't pick them up.
# See nixos-installer/README.md for usage.
{
  inputs,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
}:
let
  installerPasswordFile = "/persistent/etc/installer-password";

  mkInstaller =
    hostName: extraModules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = genSpecialArgs system;
      modules = [
        { networking.hostName = hostName; }
        inputs.disko.nixosModules.default
        {
          # No agenix here: the host's age identity doesn't exist yet on a fresh
          # install. Both accounts instead read a hash written by hand during
          # install (/ is tmpfs, so it has to live under /persistent). The
          # agenix-managed passwords take over on the first switch to the main config.
          users.users.root.hashedPasswordFile = installerPasswordFile;
          users.users.${myvars.username}.hashedPasswordFile = installerPasswordFile;
        }
      ]
      ++ (map mylib.relativeToRoot [
        "nixos-installer/configuration.nix"
        "modules/base"
        "modules/nixos/base/i18n.nix"
        "modules/nixos/base/user-group.nix"
        "modules/nixos/base/ssh.nix"
        "hosts/${hostName}/disko-fs.nix"
        "hosts/${hostName}/hardware-configuration.nix"
        "hosts/${hostName}/preservation.nix"
      ])
      ++ extraModules;
    };
in
{
  storm = mkInstaller "storm" [ (mylib.relativeToRoot "hosts/storm/amd-hardware.nix") ];
  stormlight = mkInstaller "stormlight" [
    (mylib.relativeToRoot "hosts/stormlight/amd-hardware.nix")
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];
}
