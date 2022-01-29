#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar dvi -c "$HOME"/.config/polybar/config.ini &

external_monitor=$(xrandr --query | grep 'HDMI-A-0')
if [[ $external_monitor = *connected* ]]; then
    polybar hdmi -c "$HOME"/.config/polybar/config.ini &
fi
