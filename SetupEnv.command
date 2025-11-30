#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETUP_SCRIPT="$SCRIPT_DIR/setup/minecraft-event-setup-script.sh"

chmod +x "$SETUP_SCRIPT"
exec "$SETUP_SCRIPT"
