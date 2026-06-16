#!/usr/bin/env bash
set -euo pipefail

# Force input source to ABC (English) for fzf query
command -v macism >/dev/null 2>&1 && macism com.apple.keylayout.ABC 2>/dev/null || true

TARGET_PANE=$(tmux display-message -p '#{pane_id}' 2>/dev/null || true)
[ -z "$TARGET_PANE" ] && exit 0

preview='chathist pick {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_w='chathist pick -w {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_a='chathist pick --all {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
h='mode: project | C-s:worktree / C-a:all / C-r:project'

selection=$(chathist list \
  | fzf --reverse --delimiter=$'\t' --with-nth=2.. \
        --header "$h" \
        --preview "$preview" --preview-window 'right:60%:wrap' \
        --bind "ctrl-s:reload(chathist list -w)+change-preview($preview_w)+change-header(mode: worktree | C-a:all / C-r:project)" \
        --bind "ctrl-a:reload(chathist list --all)+change-preview($preview_a)+change-header(mode: all-repos | C-s:worktree / C-r:project)" \
        --bind "ctrl-r:reload(chathist list)+change-preview($preview)+change-header($h)" \
        --bind 'shift-up:preview-up,shift-down:preview-down' \
        --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down' \
  | cut -f1 || true)

[ -z "$selection" ] && exit 0

chathist insert --all "$selection" 2>/dev/null || true
tmux send-keys -t "$TARGET_PANE" "/resume $selection"
