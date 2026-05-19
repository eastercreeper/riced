#!/usr/bin/env bash
set -euo pipefail

sink="${1:-}"
[ -n "$sink" ] || exit 1

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"$script_dir/set-default-sink.sh" "$sink"
eww update audioout_open=false
eww close audioout_dd
