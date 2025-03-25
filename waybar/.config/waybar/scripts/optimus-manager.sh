#!/bin/bash
# ~/.config/waybar/scripts/optimus-manager.sh

# Function to get current GPU mode
get_mode() {
  # Try to get current mode from optimus-manager
  if command -v optimus-manager &>/dev/null; then
    # Check if we can get the status
    STATUS=$(optimus-manager --print-mode 2>/dev/null)

    if [[ $STATUS == *"Current GPU mode"* ]]; then
      if [[ $STATUS == *"intel"* ]]; then
        echo '{"text": "󰌪 Intel", "class": "intel", "tooltip": "Current mode: Intel"}'
      elif [[ $STATUS == *"nvidia"* ]]; then
        echo '{"text": "󰾲 NVIDIA", "class": "nvidia", "tooltip": "Current mode: NVIDIA"}'
      elif [[ $STATUS == *"hybrid"* ]]; then
        echo '{"text": "󰍺 Hybrid", "class": "hybrid", "tooltip": "Current mode: Hybrid"}'
      else
        echo '{"text": "󰾆 Unknown", "class": "unknown", "tooltip": "Current mode: Unknown"}'
      fi
    else
      echo '{"text": "󰾆 Error", "class": "error", "tooltip": "Could not get Optimus mode"}'
    fi
  else
    echo '{"text": "󰾆 Not Found", "class": "error", "tooltip": "optimus-manager not found"}'
  fi
}

# Function to set next GPU mode (cycles through intel -> hybrid -> nvidia -> intel)
set_next_mode() {
  current_mode=$(optimus-manager --print-mode 2>/dev/null)

  if [[ $current_mode == *"intel"* ]]; then
    optimus-manager-qt --switch hybrid
    echo "Switching to Hybrid mode. Log out to apply changes."
  elif [[ $current_mode == *"hybrid"* ]]; then
    optimus-manager-qt --switch nvidia
    echo "Switching to NVIDIA mode. Log out to apply changes."
  elif [[ $current_mode == *"nvidia"* ]]; then
    optimus-manager-qt --switch intel
    echo "Switching to Intel mode. Log out to apply changes."
  else
    echo "Unknown current mode, cannot switch."
  fi
}

# Handle arguments
case "$1" in
  toggle)
    set_next_mode
    ;;
  *)
    get_mode
    ;;
esac
