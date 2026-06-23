#!/bin/sh
bash ~/.config/tmux/plugins/tmux-claude-signal/scripts/state.sh --state done || true
bash ~/.config/tmux/scripts/claude-notify.sh --state done || true
