if uwsm check may-start && uwsm select; then
  exec uwsm start niri.desktop
fi

