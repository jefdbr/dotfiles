#!/bin/bash

ACTIVE_WIN_CLASS=$(hyprctl activewindow -j | jq -r '.class')
VPN_CONNECTED=$(nmcli connection show --active | grep cscotun0)

if [[ "$ACTIVE_WIN_CLASS" == "Com.cisco.anyconnect.gui" && -n $VPN_CONNECTED ]]; then
    xdotool windowunmap $(xdotool getactivewindow)
else
    hyprctl dispatch killactive
fi

