#!/bin/bash
# agent-state.sh wrapper: select-pane -P によるフォーカス奪取を防止
current_pane=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
bash ~/.config/tmux/plugins/tmux-agent-indicator/scripts/agent-state.sh "$@"
new_pane=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
if [ -n "$current_pane" ] && [ "$current_pane" != "$new_pane" ]; then
    tmux select-pane -t "$current_pane"
fi
