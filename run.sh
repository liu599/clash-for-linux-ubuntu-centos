#!/bin/bash
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pkill -f clash-linux-amd64 2>/dev/null || true
sleep 1

nohup "$SERVER_DIR/clash-linux-amd64-v1.3.5" -d "$SERVER_DIR/conf" &>> "$SERVER_DIR/logs/clash.log" &
sleep 2

if ps aux | grep -q '[c]lash-linux-amd64'; then
    echo "Clash started (PID $(pgrep -f clash-linux-amd64))"
else
    echo 'Clash failed to start, check logs/clash.log'
    exit 1
fi
