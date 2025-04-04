#!/bin/bash

# Check if external monitor is connected
if hyprctl monitors | grep -q "DP-5"; then
  # External monitor connected - set it as primary
  hyprctl keyword monitor "DP-5,preferred,auto-left,1"
  hyprctl keyword monitor "eDP-1,preferred,0x0,1"

  # Move workspaces 1-3 to external monitor
  for i in {1..3}; do
    hyprctl dispatch moveworkspacetomonitor "$i DP-5"
  done

  # Move workspaces 4-5 to laptop monitor
  for i in {4..5}; do
    hyprctl dispatch moveworkspacetomonitor "$i eDP-1"
  done
else
  # Only laptop monitor - make it primary
  hyprctl keyword monitor "eDP-1,preferred,0x0,1"

  # All workspaces on laptop
  for i in {1..5}; do
    hyprctl dispatch moveworkspacetomonitor "$i eDP-1"
  done
fi
