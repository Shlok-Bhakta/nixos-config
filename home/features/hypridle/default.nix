{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";
      "$suspend_cmd" = "systemctl suspend || loginctl suspend";

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
