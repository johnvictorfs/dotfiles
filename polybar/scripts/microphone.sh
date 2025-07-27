#!/bin/sh

GRAY="%{F#757575}"
MIC_SOURCE="112935"

get_status_icon() {
  #`pactl list | sed -n '/^Source/,/^$/p' | grep Mute | grep yes > /dev/null`

  #RESULT=$(amixer get Capture | tail -2 | grep -c '\[on\]')
  RESULT=$(pamixer --get-mute --source $MIC_SOURCE)

  if [ $RESULT = true ]; then
    echo "$GRAY󰍭"
  else

    #VOLUME=$(amixer get Capture | egrep -o '([0-9]{2}%)' | tail -n 1)
    VOLUME=$(pamixer --get-volume --source $MIC_SOURCE)
    echo "󰍬 $VOLUME%"
  fi
}

get_status_icon

