#!/bin/sh
bash ~/.config/tmux/scripts/agent-state-wrapper.sh --agent claude --state done || true
bash ~/.config/tmux/scripts/claude-notify.sh --state done || true
