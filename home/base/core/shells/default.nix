{
  config,
  pkgs-unstable,
  ...
}: let
  localBin = "${config.home.homeDirectory}/.local/bin";
in {
  programs.nushell = {
    enable = true;
    package = pkgs-unstable.nushell;
    configFile.source = ./config.nu;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:${localBin}"
    '';
  };
}
