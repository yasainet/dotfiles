#!/bin/bash

# Claude Code tmux window status indicator
# Usage: status.sh <waiting|done>
# Sets tmux window options to show dot indicators via dotbar

TMUX_BIN="/opt/homebrew/bin/tmux"
ACTION="${1:-waiting}"

cat > /dev/null

[ -z "${TMUX:-}" ] && exit 0

case "$ACTION" in
  waiting)
    "$TMUX_BIN" set-option -w -t "$TMUX_PANE" @claude-waiting 1
    "$TMUX_BIN" set-option -wu -t "$TMUX_PANE" @claude-done 2>/dev/null
    ;;
  done)
    "$TMUX_BIN" set-option -wu -t "$TMUX_PANE" @claude-waiting 2>/dev/null
    "$TMUX_BIN" set-option -w -t "$TMUX_PANE" @claude-done 1
    ;;
esac
