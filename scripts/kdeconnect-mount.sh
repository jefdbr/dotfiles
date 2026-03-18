#!/usr/bin/env bash

# Usage: kdeconnect-mount.sh (-d <device_id> | -n <device_name>)

usage() {
  echo "Usage: $0 (-d <device_id> | -n <device_name>)"
  exit 1
}

# Check required utilities
for cmd in kdeconnect-cli qdbus nautilus; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Required utility '$cmd' is not installed or not available in PATH." >&2
    exit 1
  fi
done

# Parse arguments
DEVICE_ID=""
DEVICE_NAME=""

if [[ "$#" -lt 2 ]]; then
  usage
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
  -d | --device)
    DEVICE_ID="$2"
    shift 2
    ;;
  -n | --name)
    DEVICE_NAME="$2"
    shift 2
    ;;
  *)
    usage
    ;;
  esac
done

if [ -z "$DEVICE_ID" ] && [ -z "$DEVICE_NAME" ]; then
  echo "Error: Either -d <device_id> or -n <device_name> must be provided." >&2
  usage
fi

# Resolve device name to ID
if [ -n "$DEVICE_NAME" ]; then
  echo "Looking up device ID for: $DEVICE_NAME..."
  DEVICE_LIST=$(kdeconnect-cli -l)
  echo "$DEVICE_LIST"

  while IFS= read -r line; do
    if [[ "$line" =~ ^- ]]; then
      if [[ "$line" =~ -[[:space:]](.+):[[:space:]]([a-z0-9_]+)[[:space:]]\(.*\) ]]; then
        extracted_name="${BASH_REMATCH[1]}"
        extracted_id="${BASH_REMATCH[2]}"
        if [[ "$extracted_name" == "$DEVICE_NAME" ]]; then
          DEVICE_ID="$extracted_id"
          break
        fi
      fi
    fi
  done <<<"$DEVICE_LIST"

  if [ -z "$DEVICE_ID" ]; then
    echo "Error: No ID found for device '$DEVICE_NAME'. Is it paired and reachable?" >&2
    exit 1
  fi

  echo "Resolved to device ID: $DEVICE_ID"
fi

DBUS_PATH="/modules/kdeconnect/devices/$DEVICE_ID/sftp"

# Check kdeconnect is running
if ! qdbus org.kde.kdeconnect &>/dev/null; then
  echo "Error: kdeconnect DBus service is not available. Is kdeconnectd running?" >&2
  exit 1
fi

# Mount and wait for completion
echo "Mounting device $DEVICE_ID..."
qdbus org.kde.kdeconnect "$DBUS_PATH" org.kde.kdeconnect.device.sftp.mountAndWait

if [ $? -ne 0 ]; then
  echo "Error: mountAndWait failed." >&2
  echo "Mount error: $(qdbus org.kde.kdeconnect "$DBUS_PATH" org.kde.kdeconnect.device.sftp.getMountError)" >&2
  exit 1
fi

# Get the first directory from getDirectories (e.g. internal shared storage)
BROWSE_PATH=$(qdbus org.kde.kdeconnect "$DBUS_PATH" org.kde.kdeconnect.device.sftp.getDirectories | head -n1 | cut -d: -f1 | xargs)

if [ -z "$BROWSE_PATH" ]; then
  # Fall back to raw mount point if getDirectories returns nothing
  BROWSE_PATH=$(qdbus org.kde.kdeconnect "$DBUS_PATH" org.kde.kdeconnect.device.sftp.mountPoint)
fi

echo "Mounted on: $BROWSE_PATH"
