#!/bin/bash
# ~/.config/rofi/plugins/powermenu.sh

# List your options in the preferred order
options=("⏻ Shutdown" " Reboot" "󰌾 Lock Screen" "  Hibernate" " Logout" " Suspend")

# Create an associative array with commands
declare -A cmds
cmds["⏻ Shutdown"]="systemctl poweroff"
cmds[" Reboot"]="systemctl reboot"
cmds["󰌾 Lock Screen"]="playerctl --all-players pause & hyprlock"
cmds["  Hibernate"]="systemctl hibernate"
cmds[" Logout"]="hyprctl dispatch exit 0"
cmds[" Suspend"]="systemctl suspend"

# Build the menu string (each option on a new line)
menu=""
for opt in "${options[@]}"; do
    menu+="$opt\n"
done

# Invoke rofi in dmenu mode using your preferred font
selected=$(echo -e "$menu" | rofi -dmenu -i -p "Power Menu")

# Execute the selected command if one was chosen
if [ -n "$selected" ]; then
    eval "${cmds[$selected]}"
fi
