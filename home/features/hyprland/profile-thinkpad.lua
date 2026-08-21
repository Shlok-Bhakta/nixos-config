return {
  monitors = {
    {
      output = "eDP-1",
      mode = "preferred",
      position = "auto",
      scale = "1",
    },
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
  },
}
