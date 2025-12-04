{ config, lib, pkgs, ... }:

let
  cfg = config.custom.power-monitor;

  power-monitor-script = pkgs.writeShellScript "power-monitor" ''
    get_ac_status() {
      for ac in /sys/class/power_supply/AC* /sys/class/power_supply/ACAD* /sys/class/power_supply/ADP*; do
        if [ -f "$ac/online" ]; then
          cat "$ac/online" 2>/dev/null
          return
        fi
      done
      echo "1"
    }

    apply_power_settings() {
      local ac_online="$1"
      if [ "$ac_online" = "1" ]; then
        hyprctl keyword monitor "eDP-1,1920x1080@144,auto,1"
        brightnessctl set 100%
      else
        hyprctl keyword monitor "eDP-1,1920x1080@60,auto,1"
        brightnessctl set 60%
      fi
    }

    apply_power_settings "$(get_ac_status)"

    prev_status="$(get_ac_status)"
    while true; do
      sleep 2
      current_status="$(get_ac_status)"
      if [ "$current_status" != "$prev_status" ]; then
        apply_power_settings "$current_status"
        prev_status="$current_status"
      fi
    done
  '';
in
{
  options.custom.power-monitor = {
    enable = lib.mkEnableOption "power-aware monitor refresh rate switching";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.brightnessctl ];

    systemd.user.services.power-monitor = {
      Unit = {
        Description = "Power-aware monitor refresh rate switching";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${power-monitor-script}";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
