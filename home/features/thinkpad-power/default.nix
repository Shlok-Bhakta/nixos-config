{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  swwwPkg = inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww;

  wallpaperGif = "$HOME/.config/hypr/wallpaper.gif";
  wallpaperStatic = "$HOME/.config/hypr/wallpaper-static.png";

  onBattery = pkgs.writeShellScript "hypridle-on-battery" ''
    for ac in /sys/class/power_supply/AC /sys/class/power_supply/ACAD /sys/class/power_supply/ADP0 /sys/class/power_supply/AC*; do
      if [ -f "$ac/online" ]; then
        [ "$(cat "$ac/online")" = "0" ]
        exit $?
      fi
    done
    exit 1
  '';

  power-monitor = pkgs.writeShellApplication {
    name = "thinkpad-power-monitor";
    runtimeInputs = [
      pkgs.brightnessctl
      pkgs.coreutils
      hyprlandPkg
      swwwPkg
    ];
    text = ''
      set -euo pipefail

      AC_PATH=""
      for ac in /sys/class/power_supply/AC /sys/class/power_supply/ACAD /sys/class/power_supply/ADP0 /sys/class/power_supply/AC*; do
        if [ -f "$ac/online" ]; then
          AC_PATH="$ac/online"
          break
        fi
      done

      get_ac() {
        if [ -n "$AC_PATH" ]; then
          cat "$AC_PATH" 2>/dev/null || echo 1
        else
          echo 1
        fi
      }

      wait_for_hypr() {
        for _ in $(seq 1 30); do
          if hyprctl monitors >/dev/null 2>&1; then
            return 0
          fi
          sleep 1
        done
        return 1
      }

      apply_ac() {
        hyprctl eval 'hl.config({ decoration = { blur = { enabled = true }, shadow = { enabled = true } }, animations = { enabled = true } })' >/dev/null 2>&1 || true
        if [ -f "${wallpaperGif}" ]; then
          swww img "${wallpaperGif}" >/dev/null 2>&1 || true
        fi
        brightnessctl --class backlight set 100% >/dev/null 2>&1 || true
      }

      apply_bat() {
        hyprctl eval 'hl.config({ decoration = { blur = { enabled = false }, shadow = { enabled = false } }, animations = { enabled = false } })' >/dev/null 2>&1 || true
        if [ -f "${wallpaperStatic}" ]; then
          swww img "${wallpaperStatic}" >/dev/null 2>&1 || true
        fi
        brightnessctl --class backlight set 45% >/dev/null 2>&1 || true
      }

      apply() {
        if [ "$(get_ac)" = "1" ]; then
          apply_ac
        else
          apply_bat
        fi
      }

      wait_for_hypr || true
      apply

      prev="$(get_ac)"
      while true; do
        sleep 2
        current="$(get_ac)"
        if [ "$current" != "$prev" ]; then
          apply
          prev="$current"
        fi
      done
    '';
  };
in
{
  home.packages = [ pkgs.brightnessctl ];

  xdg.configFile."hypr/wallpaper-static.png".source = ../wallpapers/wallpaper.png;

  # Battery: lock 2m, screen off 2.5m, sleep 5m.
  # AC: lock 10m, screen off 12m, sleep 30m.
  services.hypridle.settings = {
    general = {
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };
    listener = lib.mkForce [
      {
        timeout = 120;
        on-timeout = "${onBattery} && loginctl lock-session";
      }
      {
        timeout = 150;
        on-timeout = "${onBattery} && hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 300;
        on-timeout = "${onBattery} && systemctl suspend";
      }
      {
        timeout = 600;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = 720;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 1800;
        on-timeout = "systemctl suspend";
      }
    ];
  };

  systemd.user.services.thinkpad-power-monitor = {
    Unit = {
      Description = "ThinkPad AC/battery compositor and display switching";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${power-monitor}/bin/thinkpad-power-monitor";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
