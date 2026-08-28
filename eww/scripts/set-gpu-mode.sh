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

# Smart notification helper that punches through Eww/cron/sudo/root environment limits
send_notification() {
  local title="$1"
  local msg="$2"
  
  if ! command -v notify-send >/dev/null 2>&1; then
    return 0
  fi

  # 1. Resolve real user (fall back to current user if not running under sudo)
  local real_user="${SUDO_USER:-$(whoami)}"
  local real_uid
  real_uid=$(id -u "$real_user")

  # 2. Extract DBUS_SESSION_BUS_ADDRESS if running in a stripped environment like Eww
  if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    if [ -s "/run/user/$real_uid/bus" ]; then
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$real_uid/bus"
    fi
  fi

  # 3. Ensure DISPLAY is populated for the notification daemon
  export DISPLAY="${DISPLAY:-:0}"

  # 4. Dispatch notification matching the true user context
  if [ "$(id -u)" -eq 0 ]; then
    sudo -u "$real_user" DISPLAY="$DISPLAY" DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-}" notify-send "$title" "$msg"
  fi
}

# Check if envycontrol is installed
if ! command -v envycontrol >/dev/null 2>&1; then
  send_notification "GPU Mode Error" "envycontrol is not installed or not in PATH."
  exit 1
fi

err_msg=""

# Helper function to run commands safely without hanging on password prompts
run_and_capture() {
  local output
  # Redirect stdin from /dev/null to prevent terminal prompt lockups
  if output="$("$@" </dev/null 2>&1)"; then
    return 0
  fi
  err_msg="$output"
  return 1
}

# 1. Try running natively (since we added NOPASSWD to sudoers, 'sudo envycontrol' will execute immediately)
if run_and_capture sudo envycontrol -s "$mode"; then
  ff=0
# 2. Backup check without sudo
elif run_and_capture envycontrol -s "$mode"; then
  ff=0
# 3. Backup non-interactive sudo
elif run_and_capture sudo -n envycontrol -s "$mode"; then
  ff=0
# 4. Fallback to graphical prompt
elif command -v pkexec >/dev/null 2>&1; then
  if run_and_capture pkexec --keep-env envycontrol -s "$mode"; then
    ff=0
  else
    ff=1
  fi
else
  ff=1
fi

# Handle the final result
if [ "$ff" -eq 0 ]; then
  send_notification "GPU Mode Changed" "Successfully switched to $mode mode. Please reboot your system."
  exit 0
else
  send_notification "GPU Mode Change Failed" "${err_msg:-All privilege methods failed. Check permissions.}"
  exit 1
fi
