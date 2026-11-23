return {
  monitors = {
    {
      output = "eDP-1",
      mode = "preferred",
      position = "auto",
      scale = "1",
    },
  },
  -- The T480s HDMI port is 1.4, so "preferred" picks 4K@30 on 4K screens.
  -- HDMI outputs get the fastest 1080p mode at >= 60 Hz instead.
  external_monitors = {
    outputs = { "HDMI-A-" },
    width = 1920,
    height = 1080,
    min_refresh = 60,
    position = "auto-right",
    scale = "1",
  },
  power_aware_wallpaper = true,
  split_workspaces = false,
  gestures = {
    {
      fingers = 3,
      direction = "horizontal",
      action = "workspace",
    },
  },
  autostart = {
    "swaync",
    "blueman-applet",
  },
  lock_on_start = true,
  kb_options = "caps:escape",
}
