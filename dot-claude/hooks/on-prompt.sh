#!/bin/sh
bash ~/.config/tmux/plugins/tmux-claude-signal/scripts/state.sh --state off || true
bash ~/.config/tmux/plugins/tmux-claude-signal/scripts/state.sh --state running || true
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
