{
  myvars,
  ...
}:
let
  caches = builtins.attrValues myvars.binaryCaches;
in
{
  nix.settings = {
    # enable flakes globally
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [ myvars.username ];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    # (all of myvars.binaryCaches)
    substituters = map (c: c.url) caches;
    trusted-public-keys = map (c: c.key) caches;

    builders-use-substitutes = true;
  };
}
