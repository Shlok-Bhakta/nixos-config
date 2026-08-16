return {
  monitors = {
    {
      output = "eDP-1",
      mode = "preferred",
      position = "auto",
      scale = "1",
    },
  },
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
