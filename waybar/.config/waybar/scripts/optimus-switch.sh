#!/bin/bash
# ~/.config/waybar/scripts/optimus-switch.sh

MODE=$1

# Ask for confirmation
CONFIRM=$(echo -e "Yes\nNo" | wofi --dmenu --prompt "Switch to $MODE mode? Logout required.")

if [[ $CONFIRM == "Yes" ]]; then
  # Switch mode
  optimus-manager-qt --switch $MODE

  # Ask if user wants to logout now
  LOGOUT=$(echo -e "Yes\nNo" | wofi --dmenu --prompt "Logout now to apply changes?")

  if [[ $LOGOUT == "Yes" ]]; then
    # Use the appropriate logout command for your environment
    hyprctl dispatch exit
  else
    notify-send "Optimus Manager" "Remember to log out to apply changes"
  fi
else
  notify-send "Optimus Manager" "Mode switch cancelled"
fi
