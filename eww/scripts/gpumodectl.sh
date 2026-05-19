#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
EWW_BIN="${EWW_BIN:-/usr/bin/eww}"
GPU_MODE_OPEN_VAR="${GPU_MODE_OPEN_VAR:-gpumode_open}"
GPU_MODE_WINDOW="${GPU_MODE_WINDOW:-gpumode_dd}"
ENVYCONTROL_BIN="$(command -v envycontrol || true)"

case "$MODE" in
  integrated|nvidia|hybrid) ;;
  *)
    echo "Usage: $0 {integrated|nvidia|hybrid}" >&2
    exit 2
    ;;
esac

if [[ -z "$ENVYCONTROL_BIN" ]]; then
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "GPU mode not changed" "envycontrol is not installed. Install it to use GPU mode switching."
  fi
  exit 1
fi

run_envycontrol() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$ENVYCONTROL_BIN" -s "$MODE"
    return 0
  fi

  if command -v sudo >/dev/null 2>&1 && sudo -n "$ENVYCONTROL_BIN" -s "$MODE" 2>/dev/null; then
    return 0
  fi

  if command -v pkexec >/dev/null 2>&1; then
    pkexec "$ENVYCONTROL_BIN" -s "$MODE"
    return 0
  fi

  return 1
}

if run_envycontrol; then
  if [[ -x "$EWW_BIN" ]]; then
    "$EWW_BIN" update "${GPU_MODE_OPEN_VAR}=false"
    "$EWW_BIN" close "$GPU_MODE_WINDOW"
  fi
  exit 0
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send \
    "GPU mode not changed" \
    "Allow envycontrol through pkexec or passwordless sudo to switch modes from Eww."
fi

exit 1
