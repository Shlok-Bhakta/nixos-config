{ pkgs, ... }:

{
  imports = [
    ../features/laptop-waybar
    ../features/power-monitor
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, preferred, auto, 1"
    ", preferred, auto, 1, mirror, eDP-1"
  ];

  wayland.windowManager.hyprland.settings.gestures = {
    gesture = "3, horizontal, workspace";
  };

  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";
      "$suspend_cmd" = "pidof steam || systemctl suspend || loginctl suspend";

      general = {
        lock_cmd = "$lock_cmd";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 240;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 540;
          on-timeout = "$suspend_cmd";
        }
      ];
    };
  };
}
