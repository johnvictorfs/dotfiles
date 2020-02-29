#echo " $(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')"

#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo ""
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo ""
  fi
  echo "%{F#2193ff}  $(bluetoothctl paired-devices | awk 'NF{print $NF; exit}')"
fi
