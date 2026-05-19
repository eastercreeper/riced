#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EWW_BIN="${EWW_BIN:-/usr/bin/eww}"
# Give the wifi panel a moment to close before toggling the user controls.
WIFI_PANEL_SETTLE_DELAY="${WIFI_PANEL_SETTLE_DELAY:-0.233}"

if [[ -x "$EWW_BIN" ]] && [[ "$("$EWW_BIN" get wifictlrev 2>/dev/null)" == "true" ]]; then
  "$SCRIPT_DIR/wifictl.sh"
  sleep "$WIFI_PANEL_SETTLE_DELAY"
fi

"$SCRIPT_DIR/usrctl.sh"
