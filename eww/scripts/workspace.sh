#!/usr/bin/env bash
# Updates eww var `workspaces-output` with exactly 6 Hyprland workspaces (1..6)
# Requires: hyprctl, jq, socat, stdbuf(coreutils)


# Prevent multiple instances
lockfile="/tmp/workspace.sh.lock"

if [ -e "$lockfile" ]; then
    exit 0
fi

trap 'rm -f "$lockfile"' EXIT
touch "$lockfile"

set -euo pipefail

ws() {
  local workspaces=6
  local workspace_data current_workspace output
  workspace_data="$(hyprctl workspaces -j)"
  current_workspace="$(hyprctl activeworkspace -j | jq -r '.id')"

  output='(box :class "ws" :halign "end" :orientation "h" :spacing 5 :space-evenly "false"'

  for ((i=1; i<=workspaces; i++)); do
    local windows cls icon
    windows="$(jq -r --argjson id "$i" '[.[] | select(.id == $id)] | .[0]?.windows // 0' <<<"$workspace_data")"

    if [[ "$current_workspace" == "$i" ]]; then
      cls="visiting"
      icon=" "
    elif [[ "$windows" -gt 0 ]]; then
      cls="occupied"
      icon=" "
    else
      cls="free"
      icon=" "
    fi

    output+=" (eventbox :onclick \"hyprctl dispatch workspace $i\" :cursor \"pointer\" :class \"$cls\" (label :text \"$icon\"))"
  done

  output+=")"
  # Force the correct config dir so the update hits the running bar
  EWW_CONFIG_DIR="$HOME/.config/eww" /usr/bin/eww update workspaces-output="$output"
}

# Find Hyprland instance signature
sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
if [[ -z "$sig" ]]; then
  sig="$(ls -td /run/user/"$UID"/hypr/*/ 2>/dev/null | head -n1 | xargs -r basename || true)"
fi

if [[ -z "$sig" ]]; then
  EWW_CONFIG_DIR="$HOME/.config/eww" /usr/bin/eww update workspaces-output='(box :class "ws" (label :text "hypr not found"))'
  exit 0
fi

SOCKET="/run/user/$UID/hypr/${sig}/.socket2.sock"

# Initial render (so circles show immediately)

# Update on workspace-related events
# Initial render
ws

# Event listener (fixed)
while read -r line; do
  case "$line" in
    workspace*|createworkspace*|destroyworkspace*|focusedmon*)
      sleep 0.03
      ws
      ;;
  esac
done < <(stdbuf -oL socat -U - "UNIX-CONNECT:${SOCKET}")