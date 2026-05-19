#!/usr/bin/env bash
set -euo pipefail

default_sink="$(pactl get-default-sink 2>/dev/null || true)"
sinks_json="$(pactl -f json list sinks 2>/dev/null || echo '[]')"

jq -c --arg default_sink "$default_sink" '
  map({
    name: (.name // ""),
    description: (
      .description
      // .properties["node.description"]
      // .properties["device.description"]
      // .name
      // "Unknown output"
    ),
    is_default: ((.name // "") == $default_sink)
  })
' <<<"$sinks_json"
