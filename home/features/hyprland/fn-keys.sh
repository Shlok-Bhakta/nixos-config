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
  local choice
  choice="$(printf '%s\n' Sound Displays Bluetooth Wi-Fi | rofi -dmenu -i -p Settings)" || exit 0
  case "$choice" in
    Sound) pavucontrol ;;
    Displays) wdisplays ;;
    Bluetooth) blueman-manager ;;
    Wi-Fi) kitty --class nmtui -e nmtui ;;
  esac
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
  kbd-backlight) kbd_backlight ;;
  *)
    echo "usage: fn-keys.sh {wifi|bluetooth|settings|kbd-backlight}" >&2
    exit 1
    ;;
esac
