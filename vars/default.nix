_: {
  username = "hz-9000";
  userfullname = "hz-9000";
  useremail = "hz-9000@proton.me";
  configDirectoryName = "nixos-config";

  # Desktop theme (colours, fonts, cursor); see ./themes/.
  theme = import ./themes/osaka-jade.nix;

  # Kubernetes cluster (Proxmox VMs); see ./k8s.nix.
  k8s = import ./k8s.nix;

  # Public keys allowed to ssh in as root and ${username}. Must be non-empty
  # before deploying the k8s nodes: they have no password login at all.
  mainSshAuthorizedKeys = [ ];
  secondaryAuthorizedKeys = [ ];

  # Binary caches, name -> { url, key }. Used by modules/base/nix.nix and
  # modules/darwin/nix.nix. flake.nix's nixConfig must be a literal, so it
  # repeats the subset it needs.
  binaryCaches = {
    nix-community = {
      url = "https://nix-community.cachix.org";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    };
    nix-gaming = {
      url = "https://nix-gaming.cachix.org";
      key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    };
    ghostty = {
      url = "https://ghostty.cachix.org";
      key = "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=";
    };
    vicinae = {
      url = "https://vicinae.cachix.org";
      key = "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=";
    };
    noctalia = {
      url = "https://noctalia.cachix.org";
      key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
    };
  };
}
