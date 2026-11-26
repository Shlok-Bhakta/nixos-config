local home = os.getenv("HOME")
package.path = home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua;" .. package.path

local profile = require("profile")
local mainMod = "SUPER"

local configuredOutputs = {}
for _, monitor in ipairs(profile.monitors) do
  hl.monitor(monitor)
  configuredOutputs[monitor.output] = true
end

-- Monitor rules only match exact names, so outputs covered by
-- profile.external_monitors get a rule built from their mode list.
local function isExternalOutput(name)
  local rule = profile.external_monitors
  if not rule or configuredOutputs[name] then
    return false
  end
  for _, prefix in ipairs(rule.outputs) do
    if name:sub(1, #prefix) == prefix then
      return true
    end
  end
  return false
end

-- Fastest mode at the wanted resolution that reaches min_refresh (59.94 Hz
-- counts as 60). Falls back to "preferred" when there is none.
local function externalMonitorMode(monitor)
  local rule = profile.external_monitors
  local best
  for _, mode in ipairs(monitor.available_modes or {}) do
    if
      mode.width == rule.width
      and mode.height == rule.height
      and mode.refresh_rate >= rule.min_refresh - 0.1
      and (not best or mode.refresh_rate > best.refresh_rate)
    then
      best = mode
    end
  end
  if not best then
    return "preferred"
  end
  return string.format("%dx%d@%.2f", best.width, best.height, best.refresh_rate)
end

local function configureExternalMonitor(monitor)
  if not isExternalOutput(monitor.name) then
    return
  end
  local rule = profile.external_monitors
  hl.monitor({
    output = monitor.name,
    mode = externalMonitorMode(monitor),
    position = rule.position,
    scale = rule.scale,
  })
end

-- Outputs already connected when the config is reloaded.
for _, monitor in ipairs(hl.get_monitors()) do
  configureExternalMonitor(monitor)
end

hl.on("monitor.added", function(monitor)
  configureExternalMonitor(monitor)

  -- Profile outputs get the wallpaper at startup. Anything else is a hotplug,
  -- and awww-daemon only restores its (empty or stale) per-output cache.
  if configuredOutputs[monitor.name] then
    return
  end
  if profile.power_aware_wallpaper then
    hl.exec_cmd("thinkpad-wallpaper-output " .. monitor.name)
  else
    hl.exec_cmd("sleep 1; awww img -o " .. monitor.name .. " " .. home .. "/.config/hypr/wallpaper.gif")
  end
end)

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
    kb_options = profile.kb_options or "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
  binds = {
    -- AeroSpace-style: workspaces remember where you came from, so
    -- SUPER + Tab keeps flipping between the last two.
    allow_workspace_cycles = true,
    -- In a tabbed group, SUPER + H / L switches tabs before leaving it.
    movefocus_cycles_groupfirst = true,
  },
  -- Tabbed groups (SUPER + ,): Catppuccin tabs matching the window borders.
  group = {
    col = {
      border_active = {
        colors = { "rgba(8aadf4ee)", "rgba(91d7e3ee)" },
        angle = 45,
      },
      border_inactive = "rgba(24273aaa)",
      border_locked_active = "rgba(f5a97fee)",
      border_locked_inactive = "rgba(24273aaa)",
    },
    groupbar = {
      font_family = "CaskaydiaCove Nerd Font",
      font_size = 12,
      font_weight_active = "bold",
      height = 22,
      gradients = true,
      rounding = 6,
      gradient_rounding = 6,
      gaps_in = 4,
      gaps_out = 4,
      indicator_height = 0,
      keep_upper_gap = false,
      text_color = "rgba(1e1e2eff)",
      text_color_inactive = "rgba(cdd6f4ff)",
      col = {
        active = "rgba(8aadf4ee)",
        inactive = "rgba(313244ee)",
        locked_active = "rgba(f5a97fee)",
        locked_inactive = "rgba(313244ee)",
      },
    },
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
  -- graphical-session-pre.target never fires here either, so start the
  -- secret service directly. T3 Code (Electron safeStorage) needs it to
  -- save remote environments.
  table.insert(commands, "systemctl --user start gnome-keyring.service")
  table.insert(
    commands,
    "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE; systemctl --user restart cliphist.service cliphist-images.service; systemctl --user start app-com.mitchellh.ghostty.service"
  )
  table.insert(commands, "awww-daemon")
  table.insert(commands, "sleep 1; waybar")

  if profile.power_aware_wallpaper then
    table.insert(commands, "sleep 1; systemctl --user restart thinkpad-power-monitor.service")
  else
    table.insert(commands, "sleep 1; awww img " .. home .. "/.config/hypr/wallpaper.gif")
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

local function mod(keys)
  return mainMod .. " + " .. keys
end

--------------------------------------------------------------------------------
-- AeroSpace-style layout
--
--   SUPER + 1-9, 0, A-Z (not H J K L V) focus workspace (follows it to its monitor)
--   SUPER + SHIFT + same key            move window to that workspace
--   SUPER + H J K L / arrows            focus window in that direction
--   SUPER + SHIFT + H J K L / arrows    move window in that direction
--   SUPER + Tab                         back to previous workspace
--   SUPER + SHIFT + Tab                 send current workspace to next monitor
--   SUPER + /                           flip split direction
--   SUPER + ,                           toggle tabbed group (accordion)
--   SUPER + - / =                       shrink / grow window
--   SUPER + SHIFT + ;                   service mode (Esc to leave)
--
-- Apps and actions live on SUPER + CTRL so every plain letter stays free:
--   SUPER + Space     launcher           SUPER + Return     terminal (Ghostty)
--   SUPER + CTRL + B  browser            SUPER + CTRL + E   files
--   SUPER + CTRL + Y  VS Code            SUPER + V          clipboard
--   SUPER + CTRL + R  calculator         SUPER + CTRL + Space  emoji
--   SUPER + CTRL + S  screenshot         SUPER + CTRL + C   color picker
--   SUPER + CTRL + W  close window       SUPER + CTRL + F   fullscreen
--   SUPER + CTRL + T  toggle floating    SUPER + CTRL + Q   lock (like macOS)
--   SUPER + `         scratchpad         SUPER + SHIFT + `  send to scratchpad
--------------------------------------------------------------------------------

local workspaceKeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
-- H J K L focus windows and V is clipboard, so they are not workspaces.
for letter in ("ABCDEFGIMNOPQRSTUWXYZ"):gmatch(".") do
  table.insert(workspaceKeys, letter)
end

for _, key in ipairs(workspaceKeys) do
  local workspace
  if key == "0" then
    workspace = 10
  elseif key:match("%d") then
    workspace = tonumber(key)
  else
    workspace = "name:" .. key
  end
  bind(mod(key), hl.dsp.focus({ workspace = workspace }))
  bind(mod("SHIFT + " .. key), hl.dsp.window.move({ workspace = workspace }))
end

local directions = {
  { keys = { "H", "left" }, direction = "left" },
  { keys = { "J", "down" }, direction = "down" },
  { keys = { "K", "up" }, direction = "up" },
  { keys = { "L", "right" }, direction = "right" },
}
for _, entry in ipairs(directions) do
  for _, key in ipairs(entry.keys) do
    bind(mod(key), hl.dsp.focus({ direction = entry.direction }))
    bind(mod("SHIFT + " .. key), hl.dsp.window.move({ direction = entry.direction }))
  end
end

bind(mod("Tab"), hl.dsp.focus({ workspace = "previous" }))
bind(mod("SHIFT + Tab"), hl.dsp.workspace.move({ monitor = "+1" }))
bind(mod("slash"), hl.dsp.layout("togglesplit"))
bind(mod("comma"), hl.dsp.group.toggle())
bind(mod("minus"), hl.dsp.window.resize({ x = -50, y = -50, relative = true }), { repeating = true })
bind(mod("equal"), hl.dsp.window.resize({ x = 50, y = 50, relative = true }), { repeating = true })
bind(mod("ALT + left"), hl.dsp.window.resize({ x = -15, y = 0, relative = true }), { repeating = true })
bind(mod("ALT + right"), hl.dsp.window.resize({ x = 15, y = 0, relative = true }), { repeating = true })
bind(mod("ALT + up"), hl.dsp.window.resize({ x = 0, y = -15, relative = true }), { repeating = true })
bind(mod("ALT + down"), hl.dsp.window.resize({ x = 0, y = 15, relative = true }), { repeating = true })
bind(mod("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
bind(mod("mouse_up"), hl.dsp.focus({ workspace = "e-1" }))
bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true })
bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Service mode, like AeroSpace's: one action, then back to normal.
bind(mod("SHIFT + semicolon"), hl.dsp.submap("service"))
hl.define_submap("service", "reset", function()
  bind("Escape", hl.dsp.submap("reset"))
  bind("R", hl.dsp.reload_config())
  bind("F", hl.dsp.window.float({ action = "toggle" }))
  bind("P", hl.dsp.window.pseudo())
  bind("Backspace", hl.dsp.window.close())
end)

bind(mod("Space"), hl.dsp.exec_cmd("rofi -show drun"))
bind(mod("Return"), hl.dsp.exec_cmd("ghostty +new-window || ghostty"))
bind(mod("CTRL + B"), hl.dsp.exec_cmd("helium"))
bind(mod("CTRL + E"), hl.dsp.exec_cmd("nautilus"))
bind(mod("CTRL + Y"), hl.dsp.exec_cmd("code"))
bind(mod("V"), hl.dsp.exec_cmd(home .. "/.config/hypr/clipboard.sh"))
bind(mod("CTRL + R"), hl.dsp.exec_cmd("rofi -show calc"))
bind(mod("CTRL + Space"), hl.dsp.exec_cmd("rofi -show emoji"))
bind(mod("CTRL + S"), hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"))
bind("Print", hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"))
bind(mod("CTRL + C"), hl.dsp.exec_cmd("hyprpicker 2>/dev/null | wl-copy"))
bind(mod("CTRL + W"), hl.dsp.window.close())
bind(mod("CTRL + F"), hl.dsp.window.fullscreen())
bind(mod("CTRL + T"), hl.dsp.window.float({ action = "toggle" }))
bind(mod("CTRL + Q"), hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
bind(mod("CTRL + SHIFT + E"), hl.dsp.exit())
bind(mod("grave"), hl.dsp.workspace.toggle_special("magic"))
bind(mod("SHIFT + grave"), hl.dsp.window.move({ workspace = "special:magic" }))
bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("bash " .. home .. "/.config/rofi/plugins/powermenu.sh"))

-- Lid close must lock immediately. logind suspends in parallel; without this
-- bind (and hypridle inhibit_sleep) resume can come back unlocked.
bind("switch:on:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { locked = true })

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

borderRule("helium-border", { class = "^helium.*" }, {
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
borderRule("discord-border", { class = "discord" }, {
  "rgba(7287fdee)",
  "rgba(209fb5ee)",
})
borderRule("floating-border", { float = true }, {
  "rgba(f5e0dcee)",
  "rgba(f2cdcdee)",
})
