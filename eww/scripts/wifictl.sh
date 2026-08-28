#!/usr/bin/env bash

EWW="/usr/bin/eww"
export EWW_CONFIG_DIR="$HOME/.config/eww"

state="$($EWW get wifictlrev 2>/dev/null || echo false)"

if [[ "$state" == "true" ]]; then
    $EWW update wifictlrev=false
    sleep 0.05
    $EWW close wifictl
else
    $EWW update wifictlrev=true
    $EWW open wifictl
fi
