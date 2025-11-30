#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REVERT_SCRIPT="$SCRIPT_DIR/setup/minecraft-event-revert-env-script.sh"

chmod +x "$REVERT_SCRIPT"
exec "$REVERT_SCRIPT"