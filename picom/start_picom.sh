#!/usr/bin/env sh

# Terminate already running picom instances
killall -q picom

# Wait until the processes have been shut down
while pgrep -x picom >/dev/null; do sleep 1; done

# Launch picom 
picom -b --config ~/.config/picom/picom.conf &

