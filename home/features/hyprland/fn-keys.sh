#!/usr/bin/env bash
set -euo pipefail

notify() {
  notify-send --app-name="ThinkPad" --expire-time=2000 "$@"
}

wifi() {
  if [ "$(nmcli radio wifi)" = "enabled" ]; then
    nmcli radio wifi off
    notify "Wi-Fi off"
  else
    nmcli radio wifi on
    notify "Wi-Fi on"
  fi
}

bluetooth() {
  if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    bluetoothctl power on >/dev/null || true
    notify "Bluetooth on"
  else
    rfkill block bluetooth
    notify "Bluetooth off"
  fi
}

settings() {
  local choice options
  options="$(printf '%s\n' Sound Displays Bluetooth Wi-Fi)"
  if command -v tlpctl >/dev/null 2>&1; then
    options+=$'\nPower profile'
  fi
  choice="$(printf '%s\n' "$options" | rofi -dmenu -i -p Settings)" || return 0
  case "$choice" in
    Sound) pavucontrol ;;
    Displays) wdisplays ;;
    Bluetooth) blueman-manager ;;
    Wi-Fi) kitty --class nmtui -e nmtui ;;
    "Power profile") power_profile ;;
  esac
}

power_profile() {
  local current choice profile options backend=tlpctl
  if ! command -v tlpctl >/dev/null 2>&1; then
    notify "Power profile switching is unavailable"
    return 1
  fi
  options="$(printf '%s\n' Performance Balanced 'Power saver')"
  if command -v thinkpad-power-profile >/dev/null 2>&1; then
    backend=thinkpad-power-profile
    options="$(printf '%s\n' Performance 'Turbo lite' Balanced 'Power saver')"
  fi
  current="$("$backend" get)" || { notify "Cannot read power profile"; return 1; }
  choice="$(printf '%s\n' "$options" | rofi -dmenu -i -p "Power profile: $current")" || return 0
  case "$choice" in
    Performance) profile=performance ;;
    "Turbo lite") profile=turbo-lite ;;
    Balanced) profile=balanced ;;
    "Power saver") profile=power-saver ;;
    *) return 0 ;;
  esac
  if "$backend" set "$profile"; then
    notify "Power profile: $choice"
  else
    notify "Could not change power profile"
    return 1
  fi
}

kbd_backlight() {
  local sysfs="" cand
  for cand in /sys/class/leds/*kbd_backlight; do
    if [ -e "$cand/brightness" ]; then
      sysfs="$cand"
      break
    fi
  done
  if [ -z "$sysfs" ]; then
    notify "No keyboard backlight"
    exit 0
  fi

  local cur max next
  cur="$(cat "$sysfs/brightness")"
  max="$(cat "$sysfs/max_brightness")"
  next="$(((cur + 1) % (max + 1)))"
  brightnessctl --device="$(basename "$sysfs")" set "$next" >/dev/null
}

case "${1:-}" in
  wifi) wifi ;;
  bluetooth) bluetooth ;;
  settings) settings ;;
  power-profile) power_profile ;;
  kbd-backlight) kbd_backlight ;;
  *)
    echo "usage: fn-keys.sh {wifi|bluetooth|settings|power-profile|kbd-backlight}" >&2
    exit 1
    ;;
esac
