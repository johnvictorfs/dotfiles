#!/bin/bash
WIFI_STATUS=$(cat /sys/class/net/wlp3s0/operstate)
ETH_STATUS=$(cat /sys/class/net/enp1s0/operstate)
# CONNECTION=$(nmcli -t -f name connection show --active)

GRAY="%{F#757575}"

ICON=""
[ $WIFI_STATUS = "up" ] && ICON=""
[ $ETH_STATUS = "up" ] && ICON=""

echo "$ICON"

