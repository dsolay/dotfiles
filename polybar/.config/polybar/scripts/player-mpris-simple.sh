#!/bin/sh

player_status=$(playerctl --player=spotifyd status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "$(playerctl --player=spotifyd metadata --format " {{ artist }} - {{ title }}")"
elif [ "$player_status" = "Paused" ]; then
    echo ""
else
    echo " $player_status"
fi
