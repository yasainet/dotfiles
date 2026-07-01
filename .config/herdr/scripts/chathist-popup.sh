#!/usr/bin/env bash
set -euo pipefail

# TODO: fix

# 注入先: agent=claude のペイン（複数時は最初の claude ペイン。last-focus は herdr に無い）
TARGET_PANE=$(herdr pane list \
  | jq -r '.result.panes[] | select(.agent=="claude") | .pane_id' | head -n1)
[ -z "$TARGET_PANE" ] && exit 0

preview='chathist pick {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_w='chathist pick -w {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_a='chathist pick --all {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
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
herdr pane send-text "$TARGET_PANE" "/resume $selection"
