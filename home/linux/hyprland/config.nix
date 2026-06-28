{ lib, ... }:
let
  browser = "zen-beta";
  terminal = "ghostty";
  inherit (lib.generators) mkLuaInline;

  # Wrap a list of shell commands in hl.on("hyprland.start", ...) so they only
  # fire once at session start, not on every config reload (exec-once semantics).
  mkStartup = cmds:
    let
      body = lib.concatMapStringsSep "\n  " (cmd: ''hl.exec_cmd("${cmd}")'') cmds;
    in {
      _args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            ${body}
          end
        '')
      ];
    };

  mkBind = key: dispatcher: {
    _args = [ key (mkLuaInline dispatcher) ];
  };

  mkBindWithOpts = key: dispatcher: opts: {
    _args = [ key (mkLuaInline dispatcher) opts ];
  };

  modKey = key: mkLuaInline ''mainMod .. " + ${key}"'';
  modBind = key: dispatcher: mkBind (modKey key) dispatcher;
  modBindWithOpts = key: dispatcher: opts: mkBindWithOpts (modKey key) dispatcher opts;
in
{
  wayland.windowManager.hyprland.settings = {
    mainMod = { _var = "SUPER"; };
    browser = { _var = browser; };
    terminal = { _var = terminal; };

    config = {
      input = {
        kb_layout = "us";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 0;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        middle_click_paste = false;
      };

      dwindle = {
        force_split = 2;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };
        shadow = {
          enabled = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
      };

      animations.enabled = true;

      binds = {
        movefocus_cycles_fullscreen = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };
    };

    curve = [
      {
        _args = [
          "fluent_decel"
          {
            type = "bezier";
            points = [
              [ 0 0.2 ]
              [ 0.4 1 ]
            ];
          }
        ];
      }
      {
        _args = [
          "easeOutCirc"
          {
            type = "bezier";
            points = [
              [ 0 0.55 ]
              [ 0.45 1 ]
            ];
          }
        ];
      }
      {
        _args = [
          "easeOutCubic"
          {
            type = "bezier";
            points = [
              [ 0.33 1 ]
              [ 0.68 1 ]
            ];
          }
        ];
      }
      {
        _args = [
          "fade_curve"
          {
            type = "bezier";
            points = [
              [ 0 0.55 ]
              [ 0.45 1 ]
            ];
          }
        ];
      }
    ];

    animation = [
      {
        leaf = "windowsIn";
        enabled = false;
        speed = 4;
        bezier = "easeOutCubic";
        style = "popin 20%";
      }
      {
        leaf = "windowsOut";
        enabled = false;
        speed = 4;
        bezier = "fluent_decel";
        style = "popin 80%";
      }
      {
        leaf = "windowsMove";
        enabled = true;
        speed = 2;
        bezier = "fluent_decel";
        style = "slide";
      }
      {
        leaf = "fadeIn";
        enabled = true;
        speed = 3;
        bezier = "fade_curve";
      }
      {
        leaf = "fadeOut";
        enabled = true;
        speed = 3;
        bezier = "fade_curve";
      }
      {
        leaf = "fadeSwitch";
        enabled = false;
        speed = 1;
        bezier = "easeOutCirc";
      }
      {
        leaf = "fadeShadow";
        enabled = true;
        speed = 10;
        bezier = "easeOutCirc";
      }
      {
        leaf = "fadeDim";
        enabled = true;
        speed = 4;
        bezier = "fluent_decel";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 4;
        bezier = "easeOutCubic";
        style = "fade";
      }
    ];

    on = [
      (mkStartup [
        "poweralertd"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "/run/wrappers/bin/gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
      ])
    ];

    bind = [
      (modBind "F1" ''hl.dsp.exec_cmd("show-keybinds")'')
      (modBind "Return" ''hl.dsp.exec_cmd(terminal)'')
      (mkBind "CTRL + ALT + T" ''hl.dsp.exec_cmd("kitty")'')
      (mkBind "ALT + Return" ''hl.dsp.exec_cmd(terminal, { float = true, size = { x = 1111, y = 700 } })'')
      (modBind "SHIFT + Return" ''hl.dsp.exec_cmd(terminal, { fullscreen = true })'')
      (modBind "B" ''hl.dsp.exec_cmd(browser, { workspace = "1 silent" })'')
      (modBind "Q" ''hl.dsp.window.close()'')
      (modBind "F" ''hl.dsp.window.fullscreen()'')
      (modBind "SHIFT + F" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
      (modBind "Space" ''hl.dsp.exec_cmd("toggle-float")'')
      (modBind "D" ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")'')
      (modBind "SHIFT + D" ''hl.dsp.exec_cmd("webcord --enable-features=UseOzonePlatform --ozone-platform=wayland")'')
      (modBind "SHIFT + S" ''hl.dsp.exec_cmd("SoundWireServer", { workspace = "5 silent" })'')
      (modBind "L" ''hl.dsp.exec_cmd("noctalia msg session lock")'')
      (modBind "SHIFT + Escape" ''hl.dsp.exec_cmd("noctalia msg panel-toggle session")'')
      (modBind "P" ''hl.dsp.window.pseudo()'')
      (modBind "X" ''hl.dsp.layout("togglesplit")'')
      (modBind "T" ''hl.dsp.exec_cmd("toggle-oppacity")'')
      (modBind "E" ''hl.dsp.exec_cmd("nemo")'')
      (mkBind "ALT + E" ''hl.dsp.exec_cmd("nemo", { float = true, size = { x = 1111, y = 700 } })'')
      (modBind "SHIFT + B" ''hl.dsp.exec_cmd("noctalia msg bar-toggle")'')
      (modBind "C" ''hl.dsp.exec_cmd("hyprpicker -a")'')
      (modBind "W" ''hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper")'')
      (modBind "SHIFT + W" ''hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper")'')
      (modBind "N" ''hl.dsp.exec_cmd("noctalia msg panel-toggle control-center")'')
      (mkBind "CTRL + SHIFT + Escape" ''hl.dsp.exec_cmd("missioncenter", { workspace = "9" })'')
      (modBind "equal" ''hl.dsp.exec_cmd("woomer")'')
      (mkBind "Print" ''hl.dsp.exec_cmd("screenshot --copy")'')
      (modBind "Print" ''hl.dsp.exec_cmd("screenshot --save")'')
      (modBind "SHIFT + Print" ''hl.dsp.exec_cmd("screenshot --swappy")'')
      (modBind "left" ''hl.dsp.focus({ direction = "left" })'')
      (modBind "right" ''hl.dsp.focus({ direction = "right" })'')
      (modBind "up" ''hl.dsp.focus({ direction = "up" })'')
      (modBind "down" ''hl.dsp.focus({ direction = "down" })'')
      (modBind "h" ''hl.dsp.focus({ direction = "left" })'')
      (modBind "j" ''hl.dsp.focus({ direction = "down" })'')
      (modBind "k" ''hl.dsp.focus({ direction = "up" })'')
      (modBind "l" ''hl.dsp.focus({ direction = "right" })'')
      (modBind "left" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "right" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "up" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "down" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "h" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "j" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "k" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (modBind "l" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
      (mkBind "CTRL + ALT + up" ''hl.dsp.focus({ window = "floating" })'')
      (mkBind "CTRL + ALT + down" ''hl.dsp.focus({ window = "tiled" })'')
      (modBind "1" ''hl.dsp.focus({ workspace = "1" })'')
      (modBind "2" ''hl.dsp.focus({ workspace = "2" })'')
      (modBind "3" ''hl.dsp.focus({ workspace = "3" })'')
      (modBind "4" ''hl.dsp.focus({ workspace = "4" })'')
      (modBind "5" ''hl.dsp.focus({ workspace = "5" })'')
      (modBind "6" ''hl.dsp.focus({ workspace = "6" })'')
      (modBind "7" ''hl.dsp.focus({ workspace = "7" })'')
      (modBind "8" ''hl.dsp.focus({ workspace = "8" })'')
      (modBind "9" ''hl.dsp.focus({ workspace = "9" })'')
      (modBind "0" ''hl.dsp.focus({ workspace = "10" })'')
      (modBind "SHIFT + 1" ''hl.dsp.window.move({ workspace = "1", follow = false })'')
      (modBind "SHIFT + 2" ''hl.dsp.window.move({ workspace = "2", follow = false })'')
      (modBind "SHIFT + 3" ''hl.dsp.window.move({ workspace = "3", follow = false })'')
      (modBind "SHIFT + 4" ''hl.dsp.window.move({ workspace = "4", follow = false })'')
      (modBind "SHIFT + 5" ''hl.dsp.window.move({ workspace = "5", follow = false })'')
      (modBind "SHIFT + 6" ''hl.dsp.window.move({ workspace = "6", follow = false })'')
      (modBind "SHIFT + 7" ''hl.dsp.window.move({ workspace = "7", follow = false })'')
      (modBind "SHIFT + 8" ''hl.dsp.window.move({ workspace = "8", follow = false })'')
      (modBind "SHIFT + 9" ''hl.dsp.window.move({ workspace = "9", follow = false })'')
      (modBind "SHIFT + 0" ''hl.dsp.window.move({ workspace = "10", follow = false })'')
      (modBind "CTRL + c" ''hl.dsp.window.move({ workspace = "empty" })'')
      (modBind "SHIFT + left" ''hl.dsp.window.move({ direction = "left" })'')
      (modBind "SHIFT + right" ''hl.dsp.window.move({ direction = "right" })'')
      (modBind "SHIFT + up" ''hl.dsp.window.move({ direction = "up" })'')
      (modBind "SHIFT + down" ''hl.dsp.window.move({ direction = "down" })'')
      (modBind "SHIFT + h" ''hl.dsp.window.move({ direction = "left" })'')
      (modBind "SHIFT + j" ''hl.dsp.window.move({ direction = "down" })'')
      (modBind "SHIFT + k" ''hl.dsp.window.move({ direction = "up" })'')
      (modBind "SHIFT + l" ''hl.dsp.window.move({ direction = "right" })'')
      (modBind "CTRL + left" ''hl.dsp.window.resize({ x = -80, y = 0, relative = true })'')
      (modBind "CTRL + right" ''hl.dsp.window.resize({ x = 80, y = 0, relative = true })'')
      (modBind "CTRL + up" ''hl.dsp.window.resize({ x = 0, y = -80, relative = true })'')
      (modBind "CTRL + down" ''hl.dsp.window.resize({ x = 0, y = 80, relative = true })'')
      (modBind "CTRL + h" ''hl.dsp.window.resize({ x = -80, y = 0, relative = true })'')
      (modBind "CTRL + j" ''hl.dsp.window.resize({ x = 0, y = 80, relative = true })'')
      (modBind "CTRL + k" ''hl.dsp.window.resize({ x = 0, y = -80, relative = true })'')
      (modBind "CTRL + l" ''hl.dsp.window.resize({ x = 80, y = 0, relative = true })'')
      (modBind "ALT + left" ''hl.dsp.window.move({ x = -80, y = 0, relative = true })'')
      (modBind "ALT + right" ''hl.dsp.window.move({ x = 80, y = 0, relative = true })'')
      (modBind "ALT + up" ''hl.dsp.window.move({ x = 0, y = -80, relative = true })'')
      (modBind "ALT + down" ''hl.dsp.window.move({ x = 0, y = 80, relative = true })'')
      (modBind "ALT + h" ''hl.dsp.window.move({ x = -80, y = 0, relative = true })'')
      (modBind "ALT + j" ''hl.dsp.window.move({ x = 0, y = 80, relative = true })'')
      (modBind "ALT + k" ''hl.dsp.window.move({ x = 0, y = -80, relative = true })'')
      (modBind "ALT + l" ''hl.dsp.window.move({ x = 80, y = 0, relative = true })'')
      (mkBind "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'')
      (mkBind "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'')
      (mkBind "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'')
      (mkBind "XF86AudioStop" ''hl.dsp.exec_cmd("playerctl stop")'')
      (modBind "mouse_down" ''hl.dsp.focus({ workspace = "e-1" })'')
      (modBind "mouse_up" ''hl.dsp.focus({ workspace = "e+1" })'')
      (modBind "V" ''hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/clipboard/history")'')
      (modBindWithOpts "mouse:272" ''hl.dsp.window.drag()'' { mouse = true; })
      (modBindWithOpts "mouse:273" ''hl.dsp.window.resize()'' { mouse = true; })
    ];

    window_rule = [
      { match.class = "^(Viewnior)$"; float = true; }
      { match.class = "^(imv)$"; float = true; }
      { match.class = "^(mpv)$"; float = true; }
      { match.class = "^(Aseprite)$"; tile = true; }
      { match.title = "^(Transmission)$"; float = true; }
      { match.title = "^(Volume Control)$"; float = true; }
      { match.title = "^(Firefox — Sharing Indicator)$"; float = true; }
      { match.title = "^(Volume Control)$"; move = "40 55%"; }
      { match.title = "^(Picture-in-Picture)$"; float = true; }
      { match.title = "^(Picture-in-Picture)$"; opacity = "1.0 override 1.0 override"; }
      { match.title = "^(Picture-in-Picture)$"; pin = true; }
      { match.title = "^(.*imv.*)$"; opacity = "1.0 override 1.0 override"; }
      { match.title = "^(.*mpv.*)$"; opacity = "1.0 override 1.0 override"; }
      { match.class = "(Aseprite)"; opacity = "1.0 override 1.0 override"; }
      { match.class = "(Unity)"; opacity = "1.0 override 1.0 override"; }
      { match.class = "(zen)"; opacity = "1.0 override 1.0 override"; }
      { match.class = "(evince)"; opacity = "1.0 override 1.0 override"; }
      { match.class = "^(${browser})$"; workspace = "1"; }
      { match.class = "^(evince)$"; workspace = "3"; }
      { match.class = "^(Gimp-2.10)$"; workspace = "4"; }
      { match.class = "^(Aseprite)$"; workspace = "4"; }
      { match.class = "^(Audacious)$"; workspace = "5"; }
      { match.class = "^(Spotify)$"; workspace = "5"; }
      { match.class = "^(com.obsproject.Studio)$"; workspace = "8"; }
      { match.class = "^(discord)$"; workspace = "10"; }
      { match.class = "^(WebCord)$"; workspace = "10"; }
      { match.class = "^(mpv)$"; idle_inhibit = "focus"; }
      { match.class = "^(firefox)$"; idle_inhibit = "fullscreen"; }
      { match.class = "^(org.gnome.Calculator)$"; float = true; }
      { match.class = "^(zenity)$"; float = true; }
      { match.class = "^(org.gnome.FileRoller)$"; float = true; }
      { match.class = "^(org.pulseaudio.pavucontrol)$"; float = true; }
      { match.class = "^(SoundWireServer)$"; float = true; }
      { match.class = "^(.sameboy-wrapped)$"; float = true; }
      { match.class = "^(file_progress)$"; float = true; }
      { match.class = "^(confirm)$"; float = true; }
      { match.class = "^(dialog)$"; float = true; }
      { match.class = "^(download)$"; float = true; }
      { match.class = "^(notification)$"; float = true; }
      { match.class = "^(error)$"; float = true; }
      { match.class = "^(confirmreset)$"; float = true; }
      { match.title = "^(Open File)$"; float = true; }
      { match.title = "^(File Upload)$"; float = true; }
      { match.title = "^(branchdialog)$"; float = true; }
      { match.title = "^(Confirm to replace files)$"; float = true; }
      { match.title = "^(File Operation Progress)$"; float = true; }
      { match.class = "^(xwaylandvideobridge)$"; opacity = "0.0 override"; }
      { match.class = "^(xwaylandvideobridge)$"; no_anim = true; }
      { match.class = "^(xwaylandvideobridge)$"; no_initial_focus = true; }
      { match.class = "^(xwaylandvideobridge)$"; no_blur = true; }
      { match.float = false; match.workspace = "w[t1]"; border_size = 0; }
      { match.float = false; match.workspace = "w[t1]"; rounding = 0; }
      { match.float = false; match.workspace = "w[tg1]"; border_size = 0; }
      { match.float = false; match.workspace = "w[tg1]"; rounding = 0; }
      { match.float = false; match.workspace = "f[1]"; border_size = 0; }
      { match.float = false; match.workspace = "f[1]"; rounding = 0; }
      {
        match = {
          class = "^()$";
          title = "^()$";
        };
        opaque = true;
      }
      {
        match = {
          class = "^()$";
          title = "^()$";
        };
        no_shadow = true;
      }
      {
        match = {
          class = "^()$";
          title = "^()$";
        };
        no_blur = true;
      }
    ];

    layer_rule = [
      { match.namespace = "vicinae"; dim_around = true; }
      {
        match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
        no_anim = true;
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      }
    ];
  };
}
