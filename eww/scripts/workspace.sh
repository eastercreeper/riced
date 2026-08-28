#!/usr/bin/env bash

# Updates Eww variable `workspaces-output`
# Keeps the original UI:
# - 6 workspaces
# - classes: visiting / occupied / free
# - Font Awesome circle icons
# - eventbox click targets
# - spacing 5
#
# Requires:
#   hyprctl
#   jq
#   socat

set -u

EWW_CONFIG_DIR="$HOME/.config/eww"
EWW_BIN="/usr/bin/eww"

# ---------------------------------------------------------
# Prevent multiple workspace listeners
# ---------------------------------------------------------

LOCKFILE="/tmp/eww-workspace-listener.lock"

cleanup() {
    rm -f "$LOCKFILE"
}

if [[ -e "$LOCKFILE" ]]; then
    old_pid="$(cat "$LOCKFILE" 2>/dev/null || true)"

    if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null; then
        echo "workspace.sh is already running with PID $old_pid"
        exit 0
    fi

    rm -f "$LOCKFILE"
fi

echo $$ > "$LOCKFILE"
trap cleanup EXIT INT TERM

# ---------------------------------------------------------
# Find Hyprland event socket
# ---------------------------------------------------------

get_socket() {
    local sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"

    if [[ -z "$sig" ]]; then
        sig="$(
            ls -td "/run/user/$UID/hypr/"*/ 2>/dev/null |
                head -n1 |
                xargs -r basename
        )"
    fi

    [[ -n "$sig" ]] || return 1

    local socket="/run/user/$UID/hypr/$sig/.socket2.sock"

    [[ -S "$socket" ]] || return 1

    printf '%s\n' "$socket"
}

# ---------------------------------------------------------
# Render workspace UI
# ---------------------------------------------------------

ws() {
    local workspaces=6
    local workspace_data
    local current_workspace
    local output

    workspace_data="$(hyprctl workspaces -j 2>/dev/null)" || return
    current_workspace="$(
        hyprctl activeworkspace -j 2>/dev/null |
            jq -r '.id'
    )" || return

    # EXACT same general UI as your original
    output='(box :class "ws" :halign "end" :orientation "h" :spacing 5 :space-evenly false'

    for ((i=1; i<=workspaces; i++)); do
        local windows
        local cls
        local icon

        windows="$(
            jq -r \
                --argjson id "$i" \
                '[.[] | select(.id == $id)] | .[0]?.windows // 0' \
                <<< "$workspace_data"
        )"

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

        # Keep your original eventbox + label structure.
        #
        # Only important change:
        # the onclick command uses the Lua dispatcher syntax
        # required by your current Hyprland setup.
        output+="
(eventbox
    :onclick \"hyprctl dispatch 'hl.dsp.focus({ workspace = \\\"$i\\\" })'\"
    :cursor \"pointer\"
    :class \"$cls\"
    (label :text \"$icon\"))"
    done

    output+=")"

    EWW_CONFIG_DIR="$EWW_CONFIG_DIR" \
        "$EWW_BIN" update workspaces-output="$output"
}

# ---------------------------------------------------------
# Dependency checks
# ---------------------------------------------------------

if ! command -v hyprctl >/dev/null 2>&1; then
    echo "workspace.sh: hyprctl not found"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "workspace.sh: jq not found"
    exit 1
fi

if ! command -v socat >/dev/null 2>&1; then
    echo "workspace.sh: socat not found"
    exit 1
fi

if [[ ! -x "$EWW_BIN" ]]; then
    echo "workspace.sh: Eww not found at $EWW_BIN"
    exit 1
fi

# ---------------------------------------------------------
# Find Hyprland socket
# ---------------------------------------------------------

SOCKET="$(get_socket)" || {
    echo "workspace.sh: could not find Hyprland socket"

    EWW_CONFIG_DIR="$EWW_CONFIG_DIR" \
        "$EWW_BIN" update \
        workspaces-output='(box :class "ws" (label :text "hypr not found"))'

    exit 1
}

# ---------------------------------------------------------
# Initial render
# ---------------------------------------------------------

ws

# ---------------------------------------------------------
# Listen for Hyprland events
# ---------------------------------------------------------

socat -u "UNIX-CONNECT:${SOCKET}" - |
while IFS= read -r line; do

    case "$line" in

        workspace\>\>*|\
        workspacev2\>\>*|\
        createworkspace\>\>*|\
        createworkspacev2\>\>*|\
        destroyworkspace\>\>*|\
        destroyworkspacev2\>\>*|\
        focusedmon\>\>*|\
        focusedmonv2\>\>*|\
        openwindow\>\>*|\
        closewindow\>\>*|\
        movewindow\>\>*|\
        movewindowv2\>\>*)

            # Tiny delay gives Hyprland enough time to update workspace JSON
            sleep 0.03
            ws
            ;;

    esac

done
