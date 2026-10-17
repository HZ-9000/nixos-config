{ inputs, myvars, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  programs.vicinae = {
    enable = true;
    enableFirefoxIntegration = true;

    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      font.normal = {
        inherit (myvars.theme.font) size;
        family = myvars.theme.font.mono;
      };
      launcher_window.opacity = 0.98;
    };
  };
}
