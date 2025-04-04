#!/bin/bash

# Define the workspace number
WORKSPACE=1

# Switch to the workspace
hyprctl dispatch workspace $WORKSPACE

# Launch Obsidian
hyprctl dispatch exec "uwsm-app -- obsidian"

# Alternative approach with Neovim
# hyprctl dispatch exec "wezterm start --class notes_terminal -- bash -c 'cd ~/notes && nvim -u ~/.config/nvim/notes.lua'"
