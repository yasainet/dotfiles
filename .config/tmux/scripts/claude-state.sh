#!/bin/bash

state=""
while [ $# -gt 0 ]; do
  case "$1" in
    --state) state="$2"; shift 2 ;;
    --agent) shift 2 ;;
    *) shift ;;
  esac
done

[ -z "$state" ] && exit 0
[ -z "$TMUX_PANE" ] && exit 0

target_window=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null)
[ -z "$target_window" ] && exit 0

active_window=$(tmux display-message -p '#{window_id}' 2>/dev/null)

if [ "$target_window" = "$active_window" ]; then
  tmux set-window-option -uqt "$target_window" window-status-style
  tmux set-window-option -uqt "$target_window" window-status-current-style
else
  case "$state" in
    needs-input)
      tmux set-window-option -qt "$target_window" window-status-style "bg=yellow,fg=black"
      tmux set-window-option -qt "$target_window" window-status-current-style "bg=yellow,fg=black"
      ;;
    done)
      tmux set-window-option -qt "$target_window" window-status-style "bg=red,fg=black"
      tmux set-window-option -qt "$target_window" window-status-current-style "bg=red,fg=black"
      ;;
    *)
      tmux set-window-option -uqt "$target_window" window-status-style
      tmux set-window-option -uqt "$target_window" window-status-current-style
      ;;
  esac
fi

tmux set-option -wt "$TMUX_PANE" @claude-state "$state" >/dev/null 2>&1
