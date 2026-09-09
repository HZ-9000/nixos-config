{ ... }:
let 
  hostName = "stormlight";
in 
{
  disabledModules = [
    ../../linux/base/sops.nix
  ];

  programs.ssh.settings."github.com".IdentityFile = "${config.home.homeDirectory}/.ssh/${hostName}";

  imports = [ ../../linux/default.nix ];
}
