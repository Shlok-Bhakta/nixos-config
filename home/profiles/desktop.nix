{ inputs, pkgs, ... }:

{
  imports = [
    ../features/waybar
  ];

  wayland.windowManager.hyprland.plugins = [
    inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1, 1920x1080@144, 0x0, 1"
    "HDMI-A-1, 1920x1080@144, -1080x-650, 1, transform, 1"
  ];
}
