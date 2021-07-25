#!/bin/sh

GRAY="%{F#757575}"

get_status_icon() {
    `pactl list | sed -n '/^Source/,/^$/p' | grep Mute | grep yes > /dev/null`

    if [ $? -eq 0 ]; then
        echo "$GRAY"
    else
        VOLUME=$(pactl list | sed -n '/^Source/,/^$/p' | egrep -o -m1 '[0-9]*%')
        echo " $VOLUME"
    fi
}

get_status_icon

