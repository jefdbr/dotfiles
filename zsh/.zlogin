if uwsm check may-start && uwsm select; then
  exec uwsm start niri.desktop
fi

# if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
#   systemctl --user is-system-running --wait
#   exec niri-session
# fi
