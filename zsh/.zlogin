if [ -z "$WAYLAND_DISPLAY" ]; then
    exec niri-session
fi
