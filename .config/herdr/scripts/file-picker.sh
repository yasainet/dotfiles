#!/usr/bin/env bash
set -euo pipefail

# TODO: fix

# 注入先: agent=claude のペイン（複数時は最初の claude ペイン）
TARGET_PANE=$(herdr pane list \
  | jq -r '.result.panes[] | select(.agent=="claude") | .pane_id' | head -n1)
[ -z "$TARGET_PANE" ] && exit 0

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

paths=()
while IFS= read -r line; do
  [[ -n $line ]] && paths+=("@$line")
done <<<"$selection"
printf -v output '%s ' "${paths[@]}"
herdr pane send-text "$TARGET_PANE" "$output"
