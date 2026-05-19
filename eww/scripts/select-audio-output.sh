#!/usr/bin/env bash
set -euo pipefail

sink="${1:-}"
[ -n "$sink" ] || exit 1

./scripts/set-default-sink.sh "$sink"
eww update audioout_open=false
eww close audioout_dd
