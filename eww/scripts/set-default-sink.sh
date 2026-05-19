#!/usr/bin/env bash
set -euo pipefail

sink="${1:-}"
[ -n "$sink" ] || exit 1

if pactl set-default-sink "$sink" >/dev/null 2>&1; then
    exit 0
fi

wpctl set-default "$sink" >/dev/null 2>&1
