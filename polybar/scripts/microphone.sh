#!/bin/sh

GRAY="%{F#757575}"

get_status_icon() {
  `pactl list | sed -n '/^Source/,/^$/p' | grep Mute | grep yes > /dev/null`

  RESULT=$(amixer get Capture | tail -2 | grep -c '\[on\]')

  if [ $RESULT -eq 0 ]; then
    echo "$GRAY"
  else
    VOLUME=$(amixer get Capture | egrep -o '([0-9]{2}%)' | tail -n 1)
    echo " $VOLUME"
  fi
}

get_status_icon

