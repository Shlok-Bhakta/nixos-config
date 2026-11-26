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
  -- Makes DP-1 the primary output for XWayland apps.
  primary_monitor = "DP-1",
  autostart = {
    "swaync",
    "discord",
  },
}
