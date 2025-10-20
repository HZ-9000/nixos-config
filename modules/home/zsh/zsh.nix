{ ... }:
{
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
