#!/bin/sh
bash ~/.config/tmux/scripts/claude-state.sh --state needs-input || true
bash ~/.config/tmux/scripts/claude-notify.sh --state needs-input || true
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
