#!/usr/bin/env bash

if [[ "$(playerctl status 2>/dev/null)" == "Playing" ]]; then
    pkill glava

    # Start Glava
    glava &
    sleep 0.6

    # Focus Glava window
    hyprctl dispatch focuswindow class:glava
    sleep 0.1

    # Fullscreen focused window
    hyprctl dispatch fullscreen

    # Music lock screen
    hyprlock --config ~/.config/hyprlock/music.conf
else
    # Normal Kairii lock screen
    hyprlock --config ~/.config/hypr/hyprlock.conf
fi

pkill glava