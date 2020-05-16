#!/bin/sh

GRAY="%{F#757575}"

MUTED=$(amixer get Capture | grep "off" | wc -c)

if [ $MUTED -eq 0 ]
then
    VOLUME=$(amixer get Capture | egrep -o -m1 '[0-9]*%')
    echo " $VOLUME"
else
    echo "$GRAY"
fi

