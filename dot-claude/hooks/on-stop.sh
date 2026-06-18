#!/bin/sh
bash ~/.config/tmux/scripts/claude-state.sh --state done || true
bash ~/.config/tmux/scripts/claude-notify.sh --state done || true
