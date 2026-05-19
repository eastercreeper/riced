#!/usr/bin/env bash
set -euo pipefail

if [ "$(eww get audioout_open)" = "true" ]; then
    eww update audioout_open=false
    eww close audioout_dd
else
    eww update audioout_open=true
    eww open audioout_dd
fi
