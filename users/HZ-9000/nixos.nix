{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.hz-9000 = {
    isNormalUser = true;
    home = "/home/hz-9000";
    extraGroups = [ "docker" "lxd" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$WreGjotvrl4o.M.p$kOYDJVFKInPMh481pWVnpe/VL23lbJU.ryZZxoD.wmpQQaqVhrI00Uz7s4Rypfp1AVmjGfFB8hprcXUU6vJQz0";
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}
