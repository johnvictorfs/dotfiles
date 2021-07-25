#!/bin/bash

BAT_PATH=/sys/class/power_supply/BAT1

[ -d $BAT_PATH ] || exit 1

STATUS=$(cat $BAT_PATH/status)
CAPACITY=$(cat $BAT_PATH/capacity)

RED="#e53935"
ORANGE="#ffb300"
YELLOW="#fdd835"
GREEN="#21d121"

CLEAR="%{U-}"

[ $CAPACITY -lt "20" ] && ICON="" && UNDERLINE="$RED"
[ $CAPACITY -ge "20" ] && ICON="" && UNDERLINE="$ORANGE"
[ $CAPACITY -ge "40" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "60" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "80" ] && ICON="" && UNDERLINE=""

# Full/Charging
[ $STATUS != "Discharging" ] && ICON=""

echo "%{u$UNDERLINE}%{T5}$ICON%{T-} $CAPACITY%$CLEAR"

