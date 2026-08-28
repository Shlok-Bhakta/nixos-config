#!/usr/bin/env bash
set -u

# greetd launches Hyprland directly, so graphical-session.target never
# becomes active. Import compositor env into systemd, then start the
# wl-paste watchers that actually fill cliphist.
if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  systemctl --user import-environment \
    WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE \
    HYPRLAND_INSTANCE_SIGNATURE >/dev/null 2>&1 || true
fi
systemctl --user start cliphist.service cliphist-images.service >/dev/null 2>&1 || true

if ! cliphist list 2>/dev/null | grep -q .; then
  notify-send --app-name="Clipboard" "Clipboard history is empty" "Copy something, then Super+V again."
  exit 0
fi

# -sync waits for cliphist stdout before drawing (rofi 2 dmenu can flash empty).
# One-column, no icons — the drun theme is a 2-column icon grid.
selection="$(
  cliphist list | rofi -dmenu -i -sync -p Clipboard \
    -no-show-icons \
    -theme-str 'listview { columns: 1; }' \
    -theme-str 'element { children: [element-text]; }'
)" || exit 0

[ -n "${selection:-}" ] || exit 0
printf '%s' "$selection" | cliphist decode | wl-copy
