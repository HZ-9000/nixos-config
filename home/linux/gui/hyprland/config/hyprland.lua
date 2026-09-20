hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})
local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
package.path = config_home .. "/hypr/?.lua;" .. package.path
pcall(require, "monitors")

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 6,
        border_size = 2,
        col = {
            active_border = "rgb(b8bb26)",
            inactive_border = "rgb(3c3836)",
        },
        layout = "scrolling",
    },
    decoration = {
        rounding = 0,
        shadow = { enabled = false },
        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696,
        },
    },
    input = {
        kb_layout = "us",
        kb_options = "grp:alt_caps_toggle",
        repeat_delay = 300,
        numlock_by_default = true,
        touchpad = { natural_scroll = true },
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + RETURN", hl.dsp.exec_cmd("ghostty --class=float"))
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("ghostty --fullscreen"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("zen-beta --new-window"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SPACE", hl.dsp.window.float())
hl.bind(mod .. " + D", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("webcord --enable-features=UseOzonePlatform --ozone-platform=wayland"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("SoundWireServer"))
hl.bind(mod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("nwg-displays"))
hl.bind(mod .. " + X", hl.dsp.group.toggle())
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nemo"))
hl.bind("ALT + E", hl.dsp.exec_cmd("nemo --new-window"))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("wl-color-picker clipboard"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("missioncenter"))
hl.bind(mod .. " + equal", hl.dsp.exec_cmd("woomer"))
hl.bind("PRINT", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mod .. " + PRINT", hl.dsp.exec_cmd([[mkdir -p "$HOME/Pictures/screenshots" && grim -g "$(slurp)" "$HOME/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png"]]))
hl.bind(mod .. " + SHIFT + PRINT", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty --filename -]]))

hl.bind(mod .. " + left", hl.dsp.layout("focus l"))
hl.bind(mod .. " + right", hl.dsp.layout("focus r"))
hl.bind(mod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mod .. " + L", hl.dsp.layout("focus r"))
for key, direction in pairs({ J = "down", K = "up" }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
end
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
hl.bind(mod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
for key, direction in pairs({ J = "down", K = "up" }) do
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/clipboard/history"))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

for _, class in ipairs({
    "^float$",
    "^Viewnior$",
    "^imv$",
    "^mpv$",
    "^org.gnome.Calculator$",
    "^zenity$",
    "^org.gnome.FileRoller$",
    "^org.pulseaudio.pavucontrol$",
    "^SoundWireServer$",
}) do
    hl.window_rule({ match = { class = class }, float = true })
end
for _, title in ipairs({
    "^Transmission$",
    "^Volume Control$",
    "^Firefox.*Sharing Indicator$",
    "^Picture-in-Picture$",
}) do
    hl.window_rule({ match = { title = title }, float = true })
end

hl.window_rule({
    match = { class = "^dev.noctalia.Noctalia$" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
    name = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})
