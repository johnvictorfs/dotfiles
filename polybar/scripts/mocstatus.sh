#!/bin/sh

if [ "$(mocp -Q %state)" != "STOP" ]; then
    SONG=$(mocp -Q %song)
    STATUS=$(mocp -Q "%ct / %tt")
    STATUS=" | $STATUS"

    ICON=
    [ "$(mocp -Q %state)" = "PAUSE" ] && ICON="" && STATUS=""

    if [ -n "$SONG" ]; then
        echo "$ICON  $SONG - $STATUS"
    else
        # Get Song name from filename if song name is not available from moc
        SONG=$(mocp -Q %file)

        # Remove absolute path from filename
        SONG=$(basename "$SONG")

        # Remove extension from filename
        SONG="${SONG%.*}"

        echo "$ICON $SONG$STATUS"
    fi
fi

