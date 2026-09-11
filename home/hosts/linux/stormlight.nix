{ ... }:
let
  hostName = "stormlight";
in
{
  programs.ssh.settings."github.com".IdentityFile = "~/.ssh/${hostName}";

  imports = [ ../../linux/default.nix ];
}
