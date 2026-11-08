# colmena - remote deployment via SSH.
#
# Only the deployment settings live here. outputs/default.nix takes each node's
# modules and specialArgs from the host's nixosConfigurations entry.
{
  targetHost,
  tags ? [ ],
  targetUser ? "root",
}:
{
  deployment = {
    inherit targetHost tags targetUser;
  };
}
