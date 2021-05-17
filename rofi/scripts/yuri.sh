#!/bin/bash

terminal="kitty"
config_folder="$HOME/.config/rofi"
rofi_command="rofi -theme $config_folder/yuri.rasi"

# Option Icons
rails=" Rails (Yuri)"
rails_webpack="  Rails + Webpack (Yuri)"
client=" React App (Client Area)"
rails_client="  Rails (Yuri) + React App (Client Area)"

# Run commads
rails_command="$config_folder/scripts/yuri_rails"
webpack_command="$config_folder/scripts/webpack_dev_server"
client_command="$config_folder/scripts/yuri_cliente"
rails_webpack_command="$config_folder/scripts/yuri_webpack"
rails_client_command="$config_folder/scripts/yuri_rails_cliente"

# Variable passed to rofi
options="$rails\n$rails_webpack\n$client\n$rails_client"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"

case $chosen in
    $rails)
        $terminal -e $rails_command
        ;;
    $rails_webpack)
        $terminal -e $rails_webpack_command
        ;;
    $client)
        $terminal -e $client_command
        ;;
    $rails_client)
        $terminal -e $rails_client_command
        ;;
esac
