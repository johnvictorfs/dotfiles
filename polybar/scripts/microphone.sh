#!/bin/sh

GRAY="%{F#b5b5b5}"

if [ $(amixer get Capture | grep "off" | wc -c) -eq 0 ]
then
    VOLUME=$(amixer get Capture | egrep -o -m1 '[0-9]*%')
    echo " $VOLUME"
else
    echo "$GRAY"
fi

