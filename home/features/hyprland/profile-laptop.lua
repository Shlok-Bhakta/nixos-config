return {
  monitors = {
    {
      output = "eDP-1",
      mode = "preferred",
      position = "auto",
      scale = "1",
    },
    {
      output = "DP-1",
      disabled = true,
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
}
