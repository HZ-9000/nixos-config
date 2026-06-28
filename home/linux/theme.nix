{ inputs, ... }:
{
  # https://github.com/catppuccin/nix
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    # Default enable for all supported programs
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "green";
  };
}
