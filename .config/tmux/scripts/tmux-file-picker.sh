#!/usr/bin/env bash
set -euo pipefail

command -v macism >/dev/null 2>&1 && macism com.apple.keylayout.ABC 2>/dev/null || true

TARGET_PANE=$(tmux display-message -p '#{pane_id}' 2>/dev/null || true)
[ -z "$TARGET_PANE" ] && exit 0

TARGET_PID=$(tmux display-message -p '#{pane_pid}' 2>/dev/null || true)
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
fd_flags='-H --follow --type f --type d --exclude .git --exclude .DS_Store'
preview_files='[[ -d {} ]] && tree -C {} | head -n 30 || bat --style=numbers --color=always {}'

selection=$(fd $fd_flags \
  | fzf --multi --reverse --freeze-right=1 \
        --prompt 'Files> ' \
        --header 'tab: multi-select / C-s: toggle grep mode' \
        --bind 'tab:toggle' \
        --preview "if [[ \$FZF_PROMPT == Grep* ]]; then $SCRIPT_DIR/grep-preview.sh {q} {}; else $preview_files; fi" \
        --preview-window 'right:60%:wrap' \
        --bind 'start:unbind(change)' \
        --bind "change:reload:rg --files-with-matches --hidden --glob '!.git' --color=never -- {q} 2>/dev/null || true" \
        --bind "ctrl-s:transform:[[ \$FZF_PROMPT == \"Files> \" ]] && echo \"change-prompt(Grep> )+disable-search+clear-query+reload(: || true)+rebind(change)\" || echo \"change-prompt(Files> )+enable-search+clear-query+unbind(change)+reload(fd $fd_flags)\"" \
  || true)

[ -z "$selection" ] && exit 0

at_prefix_mode=false
if [ -n "$TARGET_PID" ] && pgrep -P "$TARGET_PID" -f ".*claude.*|node.*gemini|codex" >/dev/null 2>&1; then
  at_prefix_mode=true
fi

paths=()
while IFS= read -r line; do
  [[ -n $line ]] && paths+=("$line")
done <<<"$selection"

if $at_prefix_mode; then
  printf -v output '@%s ' "${paths[@]}"
else
  escaped=()
  for p in "${paths[@]}"; do
    printf -v e '%q' "$p"
    escaped+=("$e")
  done
  output=$(printf '%s ' "${escaped[@]}")
fi

tmux send-keys -t "$TARGET_PANE" "$output"
