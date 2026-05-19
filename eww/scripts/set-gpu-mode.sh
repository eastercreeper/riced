#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"

case "$mode" in
  integrated|nvidia|hybrid) ;;
  *)
    echo "Usage: $0 {integrated|nvidia|hybrid}" >&2
    exit 2
    ;;
esac

if envycontrol -s "$mode" >/dev/null 2>&1; then
  exit 0
fi

if sudo -n envycontrol -s "$mode" >/dev/null 2>&1; then
  exit 0
fi

if command -v pkexec >/dev/null 2>&1; then
  pkexec envycontrol -s "$mode"
  exit $?
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "GPU mode change failed" "Set NOPASSWD for envycontrol in sudoers, or install/configure polkit."
fi

exit 1
