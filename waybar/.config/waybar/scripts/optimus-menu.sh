#!/bin/bash
# ~/.config/waybar/scripts/optimus-menu.sh

# Define the menu options
OPTIONS="Intel\nHybrid\nNVIDIA\nOpen Optimus Manager Qt"

# Show the menu with rofi
CHOSEN=$(echo -e $OPTIONS | rofi -dmenu -p "Select GPU Mode:" -theme-str 'window {width: 200px; height: 180px;}')

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
