#!/usr/bin/env bash
set -euo pipefail

EWW="/usr/bin/eww"
SINK='@DEFAULT_AUDIO_SINK@'

update_vol() {
  # Example wpctl output: "Volume: 0.55 [MUTED]"
  local out vol

  out="$(wpctl get-volume "$SINK")"
  vol="$(awk '{print int($2*100)}' <<<"$out")"

  if grep -q 'MUTED' <<<"$out"; then
    "$EWW" update volico="󰖁"
    "$EWW" update get_vol="0"
  else
    "$EWW" update volico="󰕾"
    "$EWW" update get_vol="$vol"
  fi
}

# Initialize once so the widget is correct immediately
update_vol

# Listen for changes and update when something audio-related happens
pactl subscribe | while read -r line; do
  case "$line" in
    *"on sink"*|*"on server"*|*"on card"*)
      update_vol
      ;;
  esac
done
