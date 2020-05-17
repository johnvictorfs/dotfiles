#!/bin/bash
WIFI_STATUS=$(cat /sys/class/net/wlp2s0/operstate);
ETH_STATUS=$(cat /sys/class/net/enp1s0/operstate);
CONNECTION=$(nmcli -t -f name connection show --active);

GRAY="%{F#757575}"

if [ "$WIFI_STATUS" = "up" ];
then
  ICON="";
elif [ "$ETH_STATUS" = "up" ];
then
  ICON="";
else
  ICON="";
  CONNECTION="Disconnected"
fi

echo "$ICON  $CONNECTION"

