#!/bin/sh

GRAY="%{F#757575}"
RED="%{u#e53935}"
BLUE="%{u#00acc1}"

if [ "$(mocp -Q %state)" != "STOP" ]; then
    STATUS=$(mocp -Q "%title | %ct / %tt")

    ICON="$BLUE"
    [ "$(mocp -Q %state)" = "PAUSE" ] && ICON="$GRAY" && STATUS=$(mocp -Q "%title")

    # Use polybar icon font for the icon
    ICON="%{T2}$ICON%{T-}"

    # Get Song name from filename if song name is not available from moc
    SONG=$(mocp -Q %file)

    # Remove absolute path from filename
    SONG=$(basename "$SONG")

    # Remove extension from filename
    SONG="${SONG%.*}"

    if [ -n "$STATUS" ]; then
      echo "$ICON $STATUS"
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

