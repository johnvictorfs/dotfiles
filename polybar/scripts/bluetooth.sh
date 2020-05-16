#!/bin/sh

BLUE="%{F#44D1EF}"
GRAY="%{F#b5b5b5}"

if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo ""
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo "$GRAY"
  fi

  DEVICES=$(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')
  echo "$BLUE"
fi
