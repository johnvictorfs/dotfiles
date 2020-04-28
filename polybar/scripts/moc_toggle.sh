#!/bin/sh

if [ "$(mocp -Q %state || mocp -S)" != "STOP" ]; then
    if [ "$(mocp -Q %state)" = "PAUSE" ]; then
        ICON=""
    else
        ICON=""
    fi

    echo "$ICON"
else
    echo "%{F#fc5549}"
fi

echo "%{F#fc5549}"

