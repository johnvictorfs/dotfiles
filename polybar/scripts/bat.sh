#!/bin/bash

BAT_PATH=/sys/class/power_supply/BAT0

[ -d $BAT_PATH ] || exit 1

STATUS=$(cat/status)
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

RED="#e53935"
ORANGE="#ffb300"
YELLOW="#fdd835"
GREEN="#21d121"

CLEAR="%{U-}"

[ $CAPACITY -lt "20" ] && ICON="" && UNDERLINE="$RED"
[ $CAPACITY -ge "20" ] && ICON="" && UNDERLINE="$ORANGE"
[ $CAPACITY -ge "40" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "60" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "80" ] && ICON="" && UNDERLINE=""

# Full/Charging
[ $STATUS != "Discharging" ] && ICON=""

echo "%{u$UNDERLINE}$ICON $CAPACITY%$CLEAR"

