local home = os.getenv("HOME")
package.path = home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua;" .. package.path

local profile = require("profile")
local mainMod = "SUPER"

for _, monitor in ipairs(profile.monitors) do
  hl.monitor(monitor)
end

hl.env("HYPRCURSOR_THEME", "bibata-ice-hypr")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 2,
    col = {
      active_border = {
        colors = { "rgba(8aadf4ee)", "rgba(91d7e3ee)" },
        angle = 45,
      },
      inactive_border = "rgba(24273aaa)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  dwindle = {
    preserve_split = true,
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = false,
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
  cursor = {
    no_hardware_cursors = profile.no_hardware_cursors == true,
  },
})

hl.curve("myBezier", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.25, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1.5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.5, bezier = "default" })

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

if profile.passthrough_devices then
  for _, device in ipairs(profile.passthrough_devices) do
    hl.device({
      name = device,
      output = profile.passthrough_output or "DP-1",
    })
  end
end

if profile.gestures then
  for _, gesture in ipairs(profile.gestures) do
    hl.gesture(gesture)
  end
end

hl.on("hyprland.start", function()
  local commands = {
    "dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE",
  }

  if profile.lock_on_start then
    table.insert(commands, "pidof hyprlock || hyprlock")
  end

  -- graphical-session.target has RefuseManualStart, so start session
  -- services directly after the compositor env is imported.
  table.insert(commands, "sleep 1; systemctl --user start hypridle.service")
  table.insert(
    commands,
    "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE; systemctl --user restart cliphist.service cliphist-images.service"
  )
  table.insert(commands, "swww-daemon --format argb")
  table.insert(commands, "sleep 1; waybar")

  if profile.power_aware_wallpaper then
    table.insert(commands, "sleep 1; systemctl --user restart thinkpad-power-monitor.service")
  else
    table.insert(commands, "sleep 1; swww img " .. home .. "/.config/hypr/wallpaper.gif")
  end

  for _, command in ipairs(profile.autostart or {}) do
    table.insert(commands, command)
  end

  if profile.primary_monitor then
    table.insert(commands, "xrandr --output " .. profile.primary_monitor .. " --primary")
  end

  for _, command in ipairs(commands) do
    hl.exec_cmd(command)
  end
end)

local function bind(keys, dispatcher, options)
  hl.bind(keys, dispatcher, options)
end

bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
bind(mainMod .. " + C", hl.dsp.window.close())
bind(mainMod .. " + M", hl.dsp.exit())
bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + P", hl.dsp.window.pseudo())
bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + W", hl.dsp.exec_cmd("rofi -show drun"))
bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("rofi -show calc"))
bind(mainMod .. " + V", hl.dsp.exec_cmd(home .. "/.config/hypr/clipboard.sh"))
bind(mainMod .. " + B", hl.dsp.exec_cmd("zen-beta"))
bind(mainMod .. " + Y", hl.dsp.exec_cmd("code"))
bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
-- Lid close must lock immediately. logind suspends in parallel; without this
-- bind (and hypridle inhibit_sleep) resume can come back unlocked.
bind("switch:on:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { locked = true })
bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"))
bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker 2>/dev/null | wl-copy"))
bind(mainMod .. " + T", hl.dsp.exec_cmd("rofi -show emoji"))
bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("bash " .. home .. "/.config/rofi/plugins/powermenu.sh"))
bind(mainMod .. " + CTRL + Space", hl.dsp.global(":main-menu"))
bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("magic"))
bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic" }))
bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 15, y = 0, relative = true }))
bind("SUPER + ALT + left", hl.dsp.window.resize({ x = -15, y = 0, relative = true }))
bind("SUPER + ALT + up", hl.dsp.window.resize({ x = 0, y = -15, relative = true }))
bind("SUPER + ALT + down", hl.dsp.window.resize({ x = 0, y = 15, relative = true }))
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local fnKeys = home .. "/.config/hypr/fn-keys.sh"
local mediaRepeat = { locked = true, repeating = true }
local mediaOnce = { locked = true }

bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), mediaRepeat)
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), mediaRepeat)
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), mediaOnce)
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), mediaOnce)
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), mediaOnce)
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), mediaOnce)
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), mediaOnce)
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), mediaOnce)
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --class backlight set 5%+"), mediaRepeat)
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class backlight set 5%-"), mediaRepeat)
bind("XF86Display", hl.dsp.exec_cmd("wdisplays"), mediaOnce)
bind("XF86WLAN", hl.dsp.exec_cmd("bash " .. fnKeys .. " wifi"), mediaOnce)
bind("XF86Tools", hl.dsp.exec_cmd("bash " .. fnKeys .. " settings"), mediaOnce)
bind("XF86Bluetooth", hl.dsp.exec_cmd("bash " .. fnKeys .. " bluetooth"), mediaOnce)
bind("XF86Keyboard", hl.dsp.exec_cmd("bash " .. fnKeys .. " kbd-backlight"), mediaOnce)
bind("XF86Search", hl.dsp.exec_cmd("rofi -show drun"), mediaOnce)
bind("XF86Favorites", hl.dsp.exec_cmd("rofi -show drun"), mediaOnce)

if profile.split_workspaces then
  local splitWorkspaces = require("plugins.split-monitor-workspaces")

  splitWorkspaces.setup({
    workspace_count = 10,
    monitor_priority = profile.monitor_priority,
    keep_focused = false,
    enable_notifications = true,
    enable_persistent_workspaces = false,
  })

  for workspace = 1, splitWorkspaces.get_amount_of_workspaces() do
    local key = tostring(workspace % 10)
    bind(mainMod .. " + " .. key, splitWorkspaces.workspace(tostring(workspace)))
    bind(
      mainMod .. " + SHIFT + " .. key,
      splitWorkspaces.move_to_workspace(tostring(workspace))
    )
  end

  bind(mainMod .. " + mouse_down", splitWorkspaces.cycle_workspaces("next"))
  bind(mainMod .. " + mouse_up", splitWorkspaces.cycle_workspaces("prev"))
else
  for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
  end

  bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
  bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
end

local function borderRule(name, match, colors)
  hl.window_rule({
    name = name,
    match = match,
    border_color = {
      colors = colors,
      angle = 45,
    },
  })
end

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

borderRule("brave-border", { class = "brave-browser" }, {
  "rgba(fab387ee)",
  "rgba(eba0acee)",
})
borderRule("zen-border", { class = "zen-beta" }, {
  "rgba(f9e2afee)",
  "rgba(f9e2afee)",
})
borderRule("youtube-border", { title = ".*YouTube.*" }, {
  "rgba(e78284ee)",
  "rgba(ea999cee)",
})
borderRule("catppuccin-title-border", { title = ".*[Cc]atppuccin.*" }, {
  "rgba(cba6f7ee)",
  "rgba(f38ba8ee)",
  "rgba(fab387ee)",
  "rgba(a6e3a1ee)",
  "rgba(74c7ecee)",
})
borderRule("code-border", { class = "code-url-handler" }, {
  "rgba(8bd5caee)",
  "rgba(91d7e3ee)",
})
borderRule("vesktop-border", { class = "vesktop" }, {
  "rgba(7287fdee)",
  "rgba(209fb5ee)",
})
borderRule("floating-border", { float = true }, {
  "rgba(f5e0dcee)",
  "rgba(f2cdcdee)",
})
