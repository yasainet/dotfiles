#!/usr/bin/env bash
# Claude Code の `@filename` を fzf で選ぶ。
#
# Claude Code の `@` 補完は入力欄の中で絞り込むだけで、中身を見ながら選べない。
# ここでは bat の preview を付け、Tab で複数選べるようにする。
#
# 引数なし  : 選んだ `@path` を標準出力に書く (端末から直接使う)
# --send    : 呼び出し元 pane の prompt 欄に `@path` を差し込む。
#             herdr の popup keybind から使う経路。Enter は人間が押す。
# --preview : fzf が内部で呼ぶ。単体で使うものではない。
set -uo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

# 行番号は出せない。~/.config/bat/config の --plain が command line の
# --style より強く、config を捨てると theme も一緒に失われる。
if [[ "${1:-}" == "--preview" ]]; then
  [[ -f "${2:-}" ]] || exit 0
  bat --color=always --style=plain --paging=never \
    --terminal-width="${FZF_PREVIEW_COLUMNS:-80}" "$2"
  exit 0
fi

# popup の cwd は呼び出し元と同じだが、明示されている方を優先する。
# `@` は session の cwd 基準で解決されるので、相対パスを渡す必要がある。
cd "${HERDR_ACTIVE_PANE_CWD:-$PWD}" || exit 1

# fd は .gitignore を尊重する。.git だけは中身が邪魔なので明示的に外す。
selected=$(fd --type f --hidden --exclude .git 2>/dev/null | fzf \
  --multi --height=100% --reverse --prompt='@> ' \
  --preview="'$SELF' --preview {}" \
  --preview-window='right:60%')

[[ -n "$selected" ]] || exit 0

# 複数選択は空白で繋ぐ。末尾にも空白を置き、続けて書き始められる状態にする。
mention=$(echo "$selected" | sed 's/^/@/' | tr '\n' ' ')

if [[ "${1:-}" != "--send" ]]; then
  echo "$mention"
  exit 0
fi

# 宛先。popup の中では HERDR_PANE_ID は無く、呼び出し元が
# HERDR_ACTIVE_PANE_ID に入る。pane で直接動かした場合は HERDR_PANE_ID を使う。
origin="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
[[ -n "$origin" ]] || { echo "claude-mention: 呼び出し元の pane を特定できない" >&2; exit 1; }

herdr pane send-text "$origin" "$mention"
