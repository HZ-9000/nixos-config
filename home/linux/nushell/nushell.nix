{ ... }:
{
  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      history = {
        max_size = 10000;
        file_format = "sqlite";
      };
    };

    shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  programs.starship = {
    enable = true;
  };
}
