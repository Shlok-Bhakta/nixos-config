return {
  monitors = {
    {
      output = "DP-1",
      mode = "1920x1080@144",
      position = "1920x0",
      scale = "1",
    },
    {
      output = "HDMI-A-1",
      mode = "1920x1080@144",
      position = "0x0",
      scale = "1",
    },
  },
  primary_monitor = "DP-1",
  split_workspaces = true,
  monitor_priority = { "DP-1", "HDMI-A-1" },
}
