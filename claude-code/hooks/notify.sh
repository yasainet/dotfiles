#!/bin/bash

NOTIFIER="/opt/homebrew/bin/terminal-notifier"
if [ ! -x "$NOTIFIER" ]; then
  NOTIFIER=$(which terminal-notifier 2>/dev/null || true)
fi
[ -z "$NOTIFIER" ] && exit 0

cat > /dev/null

TITLE="Claude Code"
MESSAGE="Needs attention"
if [ -n "${TMUX:-}" ]; then
  TMUX_BIN="/opt/homebrew/bin/tmux"
  TITLE=$("$TMUX_BIN" display-message -p -t "$TMUX_PANE" '#S')
  MESSAGE=$("$TMUX_BIN" display-message -p -t "$TMUX_PANE" '#I: #W')
fi

"$NOTIFIER" \
  -title "$TITLE" \
  -message "$MESSAGE" \
  -activate "com.mitchellh.ghostty" \
  -sound default \
  -ignoreDnD
