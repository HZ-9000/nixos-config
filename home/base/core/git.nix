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

  programs = {
    # GitHub CLI tool
    gh.enable = true;

    git = {
      enable = true;
      settings = {
        user.email = myvars.useremail;
        user.name = myvars.userfullname;
      };
    };

    # Git terminal UI (written in Go).
    lazygit.enable = true;
  };
}
