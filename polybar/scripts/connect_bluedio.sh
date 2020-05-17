#!/bin/sh
ICON="bluetooth"

# Set address to first argument if it exists
[ "$*" == "" ] && ADDRESS="16:08:26:18:19:57" || ADDRESS=$1

CONNECT=$(bluetoothctl connect $ADDRESS)

# Get last two words of message
MESSAGE=$(echo $CONNECT | tr ' ' '\n' | tail -2 | xargs -n5)

success() {
  DEVICE_NAME=$(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')
  notify-send -i "$ICON" "Bluetooth" "Connected successfully to $DEVICE_NAME"
}

fail() {
  notify-send -i "$ICON" "Bluetooth" "Could not connect to device: $ADDRESS"
}

[ "$MESSAGE" = "Connection successful" ] && success || fail

