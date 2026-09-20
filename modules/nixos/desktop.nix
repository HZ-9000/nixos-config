{
  pkgs,
  myvars,
  ...
}:
{
  imports = [
    ./base # modules/nixos/base/ — core NixOS settings (bootloader, i18n, ssh, users)
    ../base # modules/base/ — shared base (fonts, hardware, nix cachix, user account)
    ./desktop # modules/nixos/desktop/ — full desktop environment (Hyprland, audio, etc.)
  ];

  services = {
    xserver.enable = false; # disable xorg server
    # https://wiki.archlinux.org/title/Greetd
    greetd = {
      enable = true;
      settings = {
        default_session = {
          # The Wayland session launcher is installed for this user by Home Manager.
          user = myvars.username;
          # .wayland-session starts the configured compositor through UWSM.
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session"; # start wayland session with a TUI login manager
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
        };
      };
    };
  };

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = { };
}
