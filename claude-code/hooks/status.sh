#!/bin/bash

# Claude Code tmux status indicator
# Usage: status.sh <waiting|done>
# Sets tmux window/session options to show dot indicators via dotbar and choose-tree

TMUX_BIN="/opt/homebrew/bin/tmux"
ACTION="${1:-waiting}"

cat > /dev/null

[ -z "${TMUX:-}" ] && exit 0

SESSION=$("$TMUX_BIN" display-message -p -t "$TMUX_PANE" '#{session_id}')

case "$ACTION" in
  waiting)
    # window
    "$TMUX_BIN" set-option -w -t "$TMUX_PANE" @claude-waiting 1
    "$TMUX_BIN" set-option -wu -t "$TMUX_PANE" @claude-done 2>/dev/null
    # session
    "$TMUX_BIN" set-option -t "$SESSION" @claude-session-waiting 1
    "$TMUX_BIN" set-option -u -t "$SESSION" @claude-session-done 2>/dev/null
    ;;
  done)
    # window
    "$TMUX_BIN" set-option -wu -t "$TMUX_PANE" @claude-waiting 2>/dev/null
    "$TMUX_BIN" set-option -w -t "$TMUX_PANE" @claude-done 1
    # session
    "$TMUX_BIN" set-option -u -t "$SESSION" @claude-session-waiting 2>/dev/null
    "$TMUX_BIN" set-option -t "$SESSION" @claude-session-done 1
    ;;
esac
