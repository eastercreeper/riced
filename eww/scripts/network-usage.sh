#!/bin/bash

# Change this if you want to monitor a specific interface.
INTERFACE=$(ip route | awk '/default/ {print $5; exit}')

RX1=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes")
TX1=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes")

sleep 1

RX2=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes")
TX2=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes")

RX_RATE=$((RX2 - RX1))
TX_RATE=$((TX2 - TX1))

format_speed() {
    local bytes=$1

    if (( bytes >= 1073741824 )); then
        awk -v b="$bytes" 'BEGIN {printf "%.1f GB/s", b/1073741824}'
    elif (( bytes >= 1048576 )); then
        awk -v b="$bytes" 'BEGIN {printf "%.1f MB/s", b/1048576}'
    elif (( bytes >= 1024 )); then
        awk -v b="$bytes" 'BEGIN {printf "%.1f KB/s", b/1024}'
    else
        printf "%d B/s" "$bytes"
    fi
}

printf '{"down":"%s","up":"%s"}\n' \
    "$(format_speed "$RX_RATE")" \
    "$(format_speed "$TX_RATE")"