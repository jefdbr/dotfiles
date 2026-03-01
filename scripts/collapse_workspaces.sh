#!/usr/bin/env bash

ACTIVE_WS=$(hyprctl -j activeworkspace | jq '.id')
NEW_ACTIVE=$ACTIVE_WS

for WS in $(hyprctl -j workspaces | jq 'sort_by(.monitorID) | .[].id'); do
  GAP_FOUND=0
  EXPECTED=1
  TARGET=0
  for ID in $(hyprctl -j workspaces | jq '.[].id' | sort -n); do
    if [ "$ID" -ne "$EXPECTED" ]; then
      GAP_FOUND=1
      TARGET=$EXPECTED
      break
    fi
    if [ "$ID" -eq "$WS" ]; then
      break
    fi
    EXPECTED=$((EXPECTED + 1))
  done
  if [ "$GAP_FOUND" -eq 0 ]; then
    continue
  fi
  for ADDR in $(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WS) | .address"); do
    hyprctl dispatch movetoworkspacesilent "$TARGET",address:$ADDR 2>/dev/null >/dev/null
  done
  if [ "$WS" -eq "$ACTIVE_WS" ]; then
    NEW_ACTIVE=$TARGET
  fi
done

if [ "$NEW_ACTIVE" -ne "$ACTIVE_WS" ]; then
  hyprctl dispatch workspace "$NEW_ACTIVE"
fi
