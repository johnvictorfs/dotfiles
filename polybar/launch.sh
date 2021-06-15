 
#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

separate_bars() {
  # Multiple bars on the same line
  polybar desktop -r -c $HOME/.config/polybar/config.ini &
  polybar battery -r -c $HOME/.config/polybar/config.ini &
  polybar status_bar -r -c $HOME/.config/polybar/config.ini &
  polybar player -r -c $HOME/.config/polybar/config.ini &
  polybar date -r -c $HOME/.config/polybar/config.ini &
}

one_bar() {
  # One bar to rule them all
  if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR=$m polybar top -r -c $HOME/.config/polybar/config.ini &
    done
  else
    polybar top -r -c $HOME/.config/polybar/config.ini &
  fi
}

[ '$1' = 'multiple' ] && separate_bars || one_bar

