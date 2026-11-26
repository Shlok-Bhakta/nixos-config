{ pkgs, ... }:

{
  imports = [
    ../features/blender
    ../features/waybar
  ];

  home.sessionVariables.HYPRLAND_PRIMARY_MONITOR = "DP-1";

  xdg.configFile."hypr/profile.lua".source = ../features/hyprland/profile-pc.lua;

  # Hyprland's autostart uses it to mark DP-1 primary for XWayland.
  home.packages = [ pkgs.xrandr ];
}
