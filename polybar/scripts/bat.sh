#!/bin/bash
STATUS=$(cat /sys/class/power_supply/BAT0/status)
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

[ $CAPACITY -lt "20" ] && ICON="" && UNDERLINE="#e53935"
[ $CAPACITY -ge "20" ] && ICON="" && UNDERLINE="#ffb300"
[ $CAPACITY -ge "40" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "60" ] && ICON="" && UNDERLINE=""
[ $CAPACITY -ge "80" ] && ICON="" && UNDERLINE=""

# Full/Charging
[ $STATUS != "Discharging" ] && ICON="" # && UNDERLINE="#43a047"

echo "%{u$UNDERLINE}$ICON $CAPACITY%"

