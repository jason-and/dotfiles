#!/bin/bash
# Save as ~/.config/hypr/scripts/generate-hyprlock-config.sh

# Check which monitors are connected
connected_monitors=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

# Start with the common config
cat >~/.config/hypr/hyprlock.conf <<EOF
background {
    monitor =
    color = rgba(25, 20, 20, 1.0)
    blur_passes = 2
}
EOF

# Add an input field for each connected monitor
for monitor in $connected_monitors; do
  cat >>~/.config/hypr/hyprlock.conf <<EOF

input-field {
    monitor = $monitor
    size = 20%, 5%
    outline_thickness = 3
    inner_color = rgba(0, 0, 0, 0.0) # no fill

    outer_color = rgba(33ccffee) rgba(00ff99ee) 45deg
    check_color=rgba(00ff99ee) rgba(ff6633ee) 120deg
    fail_color=rgba(ff6633ee) rgba(ff0066ee) 40deg

    font_color = rgb(143, 143, 143)
    fade_on_empty = false
    rounding = 15

    position = 0, -20
    halign = center
    valign = center
}
EOF
done

echo "Generated hyprlock config for monitors: $connected_monitors"
