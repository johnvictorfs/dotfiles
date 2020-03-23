#!/bin/bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

rofi_command="rofi -theme ~/.config/rofi/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')

# Option Icons
shutdown="   "
reboot="   "
lock="   "
suspend="   "
logout="   "
 
# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
        i3exit shutdown
        ;;
    $reboot)
        i3exit reboot
        ;;
    $lock)
        i3exit lock
        ;;
    $suspend)
        i3exit suspend
        ;;
    $logout)
        i3exit logout
        ;;
esac
