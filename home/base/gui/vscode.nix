{ pkgs, ... }:
{
  home.packages = [
    (pkgs.vscode.overrideAttrs (old: {
      postPatch =
        # nixpkgs' vscode postPatch still targets the pre-1.144.0 ripgrep
        # layout (`@vscode/ripgrep/bin/rg`); upstream VSCode renamed/moved it
        # to `@vscode/ripgrep-universal/bin/linux-x64/rg`, which makes the
        # `rm` in postPatch fail. Remove this once nixpkgs catches up.
        (builtins.replaceStrings
          [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
          [ "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
          old.postPatch)

        + ''
          chmod +x resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign
        '';
    }))
  ];
}
