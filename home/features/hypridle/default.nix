{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";
      "$suspend_cmd" = "systemctl suspend || loginctl suspend";

      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        # Wait until hyprlock actually holds the session lock. Auto-detect can
        # miss this and let deep S3 freeze the machine still unlocked.
        inhibit_sleep = 3;
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
