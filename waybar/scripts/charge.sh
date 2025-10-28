#!/usr/bin/env bash

CHARGING_ICONS=("󰢜 " "󰂆 " "󰂇 " "󰂈 " "󰢝 " "󰂉 " "󰢞 " "󰂊 l" "󰂋 " "󰂅 " "󰂅 ")
DISCHARCHING_ICONS=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" "󰁹")

info=$(razer-cli -l)
charge=$(grep -i "charge" <<<"$info" | grep -Ev "[^0-9]0" | awk '{print $2}')
grep -i "charging" <<<"$info" | grep -iq "true" &&
  icon=${CHARGING_ICONS[$((charge / 10))]} ||
  icon=${DISCHARCHING_ICONS[$((charge / 10))]}

echo "{\"percentage\": $charge, \"text\": \"$icon\"}"
