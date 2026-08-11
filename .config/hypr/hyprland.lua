-- Hyprland 0.55+ (Lua configuration)
-- Nord-inspired, laptop-friendly defaults.

local main_mod = "SUPER"

hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 12,
    border_size = 2,
    layout = "dwindle",
    resize_on_border = true,
    col = {
      active_border = { colors = { "rgba(88c0d0ee)", "rgba(81a1c1ee)" }, angle = 45 },
      inactive_border = "rgba(4c566aaa)",
    },
  },
  decoration = {
    rounding = 12,
    active_opacity = 0.97,
    inactive_opacity = 0.90,
    blur = { enabled = true, size = 4, passes = 2 },
    shadow = { enabled = true, range = 10, render_power = 3 },
  },
  input = {
    kb_layout = "jp",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
    },
  },
  dwindle = {
    preserve_split = true,
    smart_resizing = true,
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.curve("ease_out", { type = "bezier", points = { { 0.23, 1.0 }, { 0.32, 1.0 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "ease_out" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "ease_out" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "ease_out" })

local function bind(keys, dispatcher, description, flags)
  flags = flags or {}
  flags.description = description
  hl.bind(keys, dispatcher, flags)
end

-- Launchers and session controls
bind(main_mod .. " + Q", hl.dsp.exec_cmd("alacritty -e herdr"), "Herdr terminal")
bind(main_mod .. " + X", hl.dsp.window.close(), "Close window")
bind(main_mod .. " + L", hl.dsp.exec_cmd("swaylock -f -c 1e1e2e"), "Lock screen")
bind(main_mod .. " + M", hl.dsp.exec_cmd("wlogout --protocol layer-shell"), "Session menu")
bind(main_mod .. " + SHIFT + M", hl.dsp.exit(), "Exit Hyprland")
bind(main_mod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"), "Application launcher")
bind(main_mod .. " + A", hl.dsp.exec_cmd("wofi --show drun"), "Application launcher")
bind(main_mod .. " + V", hl.dsp.window.float(), "Toggle floating")
bind(main_mod .. " + F", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind(main_mod .. " + P", hl.dsp.window.pseudo(), "Toggle pseudo-tile")
bind(main_mod .. " + J", hl.dsp.layout("togglesplit"), "Toggle split")
bind(main_mod .. " + S", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | swappy -f -']]), "Screenshot")
bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"), "Save screenshot")

-- Audio, microphone, and brightness keys.
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), "Mute speaker")
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), "Lower volume", { repeating = true })
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), "Raise volume", { repeating = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), "Mute microphone")
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), "Lower brightness", { repeating = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), "Raise brightness", { repeating = true })

-- Focus and move windows.
for key, direction in pairs({ left = "l", right = "r", up = "u", down = "d" }) do
  bind(main_mod .. " + " .. key, hl.dsp.focus({ direction = direction }), "Focus " .. key)
  bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), "Move window " .. key)
end

-- Workspaces 1-10.
for i = 1, 10 do
  local key = i == 10 and "0" or tostring(i)
  bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }), "Workspace " .. i)
  bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }), "Move to workspace " .. i)
end

bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), "Move window")
bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), "Resize window")

-- Keep the desktop useful without requiring a wallpaper daemon.
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("mako")
  hl.exec_cmd("swayidle -w")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("fcitx5 -d --replace")
  hl.exec_cmd([[find "$HOME/Pictures/wallpapers" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.jxl' \) -print -quit | grep -q . && hyprpaper]])
end)

-- Keep launchers and utility windows light, rounded, and out of the tiling tree.
hl.window_rule({ match = { class = "^(wofi|wlogout|pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(Alacritty|alacritty)$" }, opacity = "0.96 0.88" })
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.25 })
