#!/bin/sh

BLUE="%{u#44D1EF}"
GRAY="%{F#757575}"

INACTIVE_ICON=""
ACTIVE_ICON=""

# Bluetooth turned off
[ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ] && echo "$GRAY$INACTIVE_ICON"

# No bluetooth devices connected
[ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ] && echo "$GRAY$INACTIVE_ICON"

#DEVICES=$(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')
echo "$ACTIVE_ICON"
