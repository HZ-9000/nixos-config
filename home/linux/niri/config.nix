{ ... }:
let
  browser = "zen-beta";
  terminal = "ghostty";
in
{
  programs.niri.settings = {
    prefer-no-csd = true;

    spawn-at-startup = [
      { argv = [ "poweralertd" ]; }
      { sh = "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"; }
    ];

    cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
    };

    input = {
      keyboard = {
        numlock = true;
        repeat-delay = 300;
        xkb = {
          layout = "us";
          options = "grp:alt_caps_toggle";
        };
      };
      touchpad.natural-scroll = true;
    };

    layout = {
      gaps = 6;
      border = {
        enable = true;
        width = 2;
      };
      focus-ring.enable = false;
    };

    binds = {
      "Mod+F1".action.show-hotkey-overlay = { };
      "Mod+Return".action.spawn = terminal;
      "Ctrl+Alt+T".action.spawn = "kitty";
      "Alt+Return".action.spawn-sh = "${terminal} --class=float";
      "Mod+Shift+Return".action.spawn-sh = "${terminal} --fullscreen";
      "Mod+B".action.spawn-sh = "${browser} --new-window";
      "Mod+Q".action.close-window = { };
      "Ctrl+Alt+Delete".action.quit = { };
      "Mod+F".action.fullscreen-window = { };
      "Mod+Shift+F".action.toggle-windowed-fullscreen = { };
      "Mod+Space".action.toggle-window-floating = { };
      "Mod+D".action.spawn = [
        "vicinae"
        "toggle"
      ];
      "Mod+Shift+D".action.spawn-sh =
        "webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
      "Mod+Shift+S".action.spawn-sh = "SoundWireServer";
      "Mod+Shift+Escape".action.spawn-sh = "noctalia msg panel-toggle session";
      "Ctrl+Alt+L".action.spawn-sh = "noctalia msg session lock";
      "Mod+X".action.toggle-column-tabbed-display = { };
      "Mod+E".action.spawn = "nemo";
      "Alt+E".action.spawn-sh = "nemo --new-window";
      "Mod+Shift+B".action.spawn-sh = "noctalia msg bar-toggle";
      "Mod+C".action.spawn-sh = "wl-color-picker clipboard";
      "Mod+W".action.spawn-sh = "noctalia msg panel-toggle wallpaper";
      "Mod+Shift+W".action.spawn-sh = "noctalia msg panel-toggle wallpaper";
      "Mod+N".action.spawn-sh = "noctalia msg panel-toggle control-center";
      "Ctrl+Shift+Escape".action.spawn = "missioncenter";
      "Mod+equal".action.spawn = "woomer";
      "Print".action.spawn-sh = "grim -g \"$(slurp)\" - | wl-copy";
      "Mod+Print".action.spawn-sh =
        "mkdir -p \"$HOME/Pictures/screenshots\" && grim -g \"$(slurp)\" \"$HOME/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png\"";
      "Mod+Shift+Print".action.spawn-sh =
        "grim -g \"$(slurp)\" - | swappy -f -";

      "Mod+Left".action.focus-column-left = { };
      "Mod+Right".action.focus-column-right = { };
      "Mod+Up".action.focus-window-up = { };
      "Mod+Down".action.focus-window-down = { };
      "Mod+H".action.focus-column-left = { };
      "Mod+J".action.focus-window-down = { };
      "Mod+K".action.focus-window-up = { };
      "Mod+l".action.focus-column-right = { };

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+0".action.focus-workspace = 10;

      "Mod+Shift+1".action.move-window-to-workspace = [
        { focus = false; }
        1
      ];
      "Mod+Shift+2".action.move-window-to-workspace = [
        { focus = false; }
        2
      ];
      "Mod+Shift+3".action.move-window-to-workspace = [
        { focus = false; }
        3
      ];
      "Mod+Shift+4".action.move-window-to-workspace = [
        { focus = false; }
        4
      ];
      "Mod+Shift+5".action.move-window-to-workspace = [
        { focus = false; }
        5
      ];
      "Mod+Shift+6".action.move-window-to-workspace = [
        { focus = false; }
        6
      ];
      "Mod+Shift+7".action.move-window-to-workspace = [
        { focus = false; }
        7
      ];
      "Mod+Shift+8".action.move-window-to-workspace = [
        { focus = false; }
        8
      ];
      "Mod+Shift+9".action.move-window-to-workspace = [
        { focus = false; }
        9
      ];
      "Mod+Shift+0".action.move-window-to-workspace = [
        { focus = false; }
        10
      ];

      "Mod+Shift+Left".action.move-column-left = { };
      "Mod+Shift+Right".action.move-column-right = { };
      "Mod+Shift+Up".action.move-window-up = { };
      "Mod+Shift+Down".action.move-window-down = { };
      "Mod+Shift+H".action.move-column-left = { };
      "Mod+Shift+J".action.move-window-down = { };
      "Mod+Shift+K".action.move-window-up = { };
      "Mod+Shift+l".action.move-column-right = { };

      "Mod+WheelScrollDown".action.focus-workspace-down = { };
      "Mod+WheelScrollDown".cooldown-ms = 150;
      "Mod+WheelScrollUp".action.focus-workspace-up = { };
      "Mod+WheelScrollUp".cooldown-ms = 150;
      "Mod+V".action.spawn = [
        "vicinae"
        "vicinae://extensions/vicinae/clipboard/history"
      ];

      "XF86AudioPlay".action.spawn-sh = "playerctl play-pause";
      "XF86AudioNext".action.spawn-sh = "playerctl next";
      "XF86AudioPrev".action.spawn-sh = "playerctl previous";
      "XF86AudioStop".action.spawn-sh = "playerctl stop";
    };

    window-rules = [
      {
        matches = [ { app-id = "^Viewnior$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^imv$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^mpv$"; } ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Transmission$"; } ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Volume Control$"; } ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Firefox — Sharing Indicator$"; } ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Picture-in-Picture$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^org.gnome.Calculator$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^zenity$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^org.gnome.FileRoller$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^org.pulseaudio.pavucontrol$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^SoundWireServer$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^${browser}$"; } ];
        open-on-workspace = "1";
      }
      {
        matches = [ { app-id = "^evince$"; } ];
        open-on-workspace = "3";
      }
      {
        matches = [ { app-id = "^Gimp-2.10$"; } ];
        open-on-workspace = "4";
      }
      {
        matches = [ { app-id = "^Aseprite$"; } ];
        open-on-workspace = "4";
      }
      {
        matches = [ { app-id = "^Audacious$"; } ];
        open-on-workspace = "5";
      }
      {
        matches = [ { app-id = "^Spotify$"; } ];
        open-on-workspace = "5";
      }
      {
        matches = [ { app-id = "^com.obsproject.Studio$"; } ];
        open-on-workspace = "8";
      }
      {
        matches = [ { app-id = "^discord$"; } ];
        open-on-workspace = "10";
      }
      {
        matches = [ { app-id = "^WebCord$"; } ];
        open-on-workspace = "10";
      }
    ];
  };
}
