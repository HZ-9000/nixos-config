{
  myvars,
  ...
}:
let
  caches = with myvars.binaryCaches; [
    nix-community
    ghostty
  ];
in
{
  nix.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [ myvars.username ];

    substituters = map (c: c.url) caches;
    trusted-public-keys = map (c: c.key) caches;

    builders-use-substitutes = true;
  };
}
