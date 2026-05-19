#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
EWW_BIN="${EWW_BIN:-/usr/bin/eww}"
ENVYCONTROL_BIN="$(command -v envycontrol || true)"

case "$MODE" in
  integrated|nvidia|hybrid) ;;
  *)
    echo "Usage: $0 {integrated|nvidia|hybrid}" >&2
    exit 64
    ;;
esac

if [[ -z "$ENVYCONTROL_BIN" ]]; then
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "GPU mode not changed" "envycontrol is not installed."
  fi
  exit 1
fi

run_envycontrol() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$ENVYCONTROL_BIN" -s "$MODE"
  elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo -n "$ENVYCONTROL_BIN" -s "$MODE"
  elif command -v pkexec >/dev/null 2>&1; then
    pkexec "$ENVYCONTROL_BIN" -s "$MODE"
  else
    return 1
  fi
}

if run_envycontrol; then
  if [[ -x "$EWW_BIN" ]]; then
    "$EWW_BIN" update gpumode_open=false
    "$EWW_BIN" close gpumode_dd
  fi
  exit 0
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send \
    "GPU mode not changed" \
    "Allow envycontrol through pkexec or passwordless sudo to switch modes from Eww."
fi

exit 1
