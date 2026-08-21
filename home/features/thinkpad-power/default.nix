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
    for supply in /sys/class/power_supply/*; do
      if [ -f "$supply/online" ] && [ "$(cat "$supply/online" 2>/dev/null)" = "1" ]; then
        exit 1
      fi
    done
    exit 0
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

      get_ac() {
        for supply in /sys/class/power_supply/*; do
          if [ -f "$supply/online" ] && [ "$(cat "$supply/online" 2>/dev/null)" = "1" ]; then
            echo 1
            return
          fi
        done

        # Battery is the safe default when adapters are absent or unreadable.
        echo 0
      }

      wait_for_hypr() {
        while true; do
          if hyprctl monitors >/dev/null 2>&1; then
            return 0
          fi
          sleep 1
        done
      }

      wait_for_swww() {
        while ! swww query >/dev/null 2>&1; do
          sleep 1
        done
      }

      apply_ac() {
        echo "Applying AC desktop settings"
        hyprctl eval 'hl.config({ decoration = { blur = { enabled = true }, shadow = { enabled = true } }, animations = { enabled = true } })'
        if [ -f "${wallpaperGif}" ]; then
          swww img "${wallpaperGif}"
        fi
        if [ "$1" = "set-brightness" ]; then
          brightnessctl --class backlight set 100%
        fi
      }

      apply_bat() {
        echo "Applying battery desktop settings"
        hyprctl eval 'hl.config({ decoration = { blur = { enabled = false }, shadow = { enabled = false } }, animations = { enabled = false } })'
        if [ -f "${wallpaperStatic}" ]; then
          swww img "${wallpaperStatic}"
        fi
        if [ "$1" = "set-brightness" ]; then
          brightnessctl --class backlight set 45%
        fi
      }

      apply() {
        if [ "$(get_ac)" = "1" ]; then
          apply_ac "$1" || echo "Failed to fully apply AC desktop settings" >&2
        else
          apply_bat "$1" || echo "Failed to fully apply battery desktop settings" >&2
        fi
      }

      wait_for_hypr
      wait_for_swww
      apply set-brightness

      prev="$(get_ac)"
      reconcile_ticks=0
      while true; do
        sleep 2
        current="$(get_ac)"
        reconcile_ticks=$((reconcile_ticks + 1))
        if [ "$current" != "$prev" ]; then
          apply set-brightness
          prev="$current"
          reconcile_ticks=0
        elif [ "$reconcile_ticks" -ge 30 ]; then
          apply keep-brightness
          reconcile_ticks=0
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
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
