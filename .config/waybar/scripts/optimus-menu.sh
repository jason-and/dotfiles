#!/bin/bash
# ~/.config/waybar/scripts/optimus-menu.sh

# Define the menu
OPTIONS="Intel\nHybrid\nNVIDIA\nOpen Optimus Manager Qt"

# Show the menu with wofi or rofi
CHOSEN=$(echo -e $OPTIONS | wofi --dmenu --prompt "Select GPU Mode:" --width 200 --height 180)

case $CHOSEN in
  "Intel")
    ~/.config/waybar/scripts/optimus-switch.sh intel
    ;;
  "Hybrid")
    ~/.config/waybar/scripts/optimus-switch.sh hybrid
    ;;
  "NVIDIA")
    ~/.config/waybar/scripts/optimus-switch.sh nvidia
    ;;
  "Open Optimus Manager Qt")
    optimus-manager-qt &
    ;;
esac
