{
  config,
  lib,
  myvars,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  # GitHub CLI tool
  # https://cli.github.com/manual/
  programs.gh.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user.email = myvars.useremail;
      user.name = myvars.userfullname;
    };
  };

  # Git terminal UI (written in go).
  programs.lazygit.enable = true;
}
