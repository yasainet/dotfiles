#!/bin/sh
bash ~/.config/tmux/scripts/agent-state-wrapper.sh --agent claude --state running || true
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
