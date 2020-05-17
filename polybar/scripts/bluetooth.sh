#!/bin/sh

BLUE="%{u#44D1EF}"
GRAY="%{F#757575}"

INACTIVE_ICON=""
ACTIVE_ICON=""

if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "$INACTIVE_ICON"
else
  [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ] && echo "$GRAY"

  # DEVICES=$(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')
  echo "$BLUE$ACTIVE_ICON"
fi
