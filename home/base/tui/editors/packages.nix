{
  pkgs,
  ...
}: {
  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };

  home.packages = with pkgs; (
    # -*- Data & Configuration Languages -*-#
    [
      #-- nix
      nil
      # rnix-lsp
      # nixd
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      alejandra # Nix Code Formatter
    ]
    ++
    #-*- General Purpose Languages -*-#
    [
      #-- c/c++
      cmake
      cmake-language-server
      gnumake
      # c/c++ compiler, required by nvim-treesitter!
      gcc
      gdb
      #-- python
      pyright # python language server
      (python311.withPackages (
        ps:
          with ps; [
            ruff

            # my commonly used python packages
            jupyter
            ipython
          ]
      ))
      #-- lua
      stylua
      lua-language-server
    ]
    #-*- Web Development -*-#
    ++ [
      nodePackages.nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      # HTML/CSS/JSON/ESLint language servers extracted from vscode
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
    ]
  );
}
