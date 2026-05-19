#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"

case "$mode" in
  integrated|nvidia|hybrid) ;;
  *)
    echo "Usage: $0 {integrated|nvidia|hybrid}" >&2
    exit 1
    ;;
esac

if ! command -v envycontrol >/dev/null 2>&1; then
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "GPU mode change failed" "envycontrol is not installed or not in PATH."
  fi
  exit 1
fi

err_msg=""

run_and_capture() {
  local output
  if output="$("$@" 2>&1)"; then
    return 0
  fi
  err_msg="$output"
  return 1
}

if run_and_capture envycontrol -s "$mode"; then
  exit 0
fi

if run_and_capture sudo -n envycontrol -s "$mode"; then
  exit 0
fi

if command -v pkexec >/dev/null 2>&1; then
  if run_and_capture pkexec envycontrol -s "$mode"; then
    exit 0
  fi
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "GPU mode change failed" "${err_msg:-All privilege methods failed. Check permissions and configure sudoers/polkit for envycontrol.}"
fi

exit 1
