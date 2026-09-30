#!/usr/bin/env bash

# Find the name of the focused monitor
MON=$(hyprctl activeworkspace | grep -oP 'on monitor \K[^:]+')

# Define your current wallpaper path here
WALLPAPER="$HOME/Pictures/Wallpapers/your_wallpaper.jpg"

if hyprctl monitors | grep -A 12 "$MON" | grep -q "transform: 2"; then
    # Reset layout to normal
    hyprctl eval "hl.monitor({ output = \"$MON\", mode = \"preferred\", position = \"auto\", scale = 1, transform = 0 })"
    
    # Trigger an immediate swww wipe/wave animation right as it spins back
    swww img "$WALLPAPER" --outputs "$MON" --transition-type wave --transition-fps 144 --transition-duration 0.5
else
    # Rotate 180 degrees
    hyprctl eval "hl.monitor({ output = \"$MON\", mode = \"preferred\", position = \"auto\", scale = 1, transform = 2 })"
    
    # Trigger an immediate swww wipe/wave animation right as it turns upside down
    swww img "$WALLPAPER" --outputs "$MON" --transition-type wave --transition-fps 144 --transition-duration 0.5
fi
