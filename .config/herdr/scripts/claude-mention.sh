#!/usr/bin/env bash
# Claude Code の `@filename` を fzf で選ぶ。
#
# Claude Code の `@` 補完は入力欄の中で絞り込むだけで、中身を見ながら選べない。
# ここでは bat の preview を付け、Tab で複数選べるようにする。
#
# 探し方は fzf の中で C-t で切り替える。nvim の <leader>ff と <leader>fg に
# 対応する 2 つを往復する。
#   @file : fd でファイル名を絞る。fzf が自前で絞り込む
#   rg    : 中身を検索する。打鍵ごとに rg を回すので fzf の検索は止める
#
# rg で選んでもプロンプトに入るのはパスだけ。`@` は行番号を解釈せず、
# ファイル全体を読み込む。同じファイルへの複数ヒットは 1 つに畳む。
#
# 引数なし  : 選んだ `@path` を標準出力に書く (端末から直接使う)
# --send    : 呼び出し元 pane の prompt 欄に `@path` を差し込む。
#             herdr の popup keybind から使う経路。Enter は人間が押す。
# --grep    : fzf が reload で呼ぶ。単体で使うものではない。
# --preview : fzf が内部で呼ぶ。単体で使うものではない。
set -uo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

FD_CMD=(fd --type f --hidden --exclude .git)

# preview は mode で分けない。行をそのまま受け取り、`path:行番号:` の形なら
# rg の行として扱う。mode ごとに change-preview で差し替える手は使えない。
# transform が吐く action の placeholder は、その時点の行で展開されて固定され、
# 以後どこへ移動しても同じファイルを見続ける。
#
# 行番号は出せない。~/.config/bat/config の --plain が command line の
# --style より強く、config を捨てると theme も一緒に失われる。--highlight-line
# は plain でも効くので、当たった行は背景色で示す。
#
# 当たった行は preview の中ほどに置きたい。fzf の change-preview-window に
# offset を渡す手もあるが、表示範囲を bat 側で決めれば bind が 1 つ減る。
if [[ "${1:-}" == "--preview" ]]; then
  if [[ "${2:-}" =~ ^(.+):([0-9]+): ]]; then
    file="${BASH_REMATCH[1]}"
    line="${BASH_REMATCH[2]}"
  else
    file="${2:-}"
    line=""
  fi
  [[ -f "$file" ]] || exit 0

  args=(--color=always --style=plain --paging=never
        --terminal-width="${FZF_PREVIEW_COLUMNS:-80}")

  if [[ -n "$line" ]]; then
    start=$(( line - ${FZF_PREVIEW_LINES:-40} / 2 ))
    (( start < 1 )) && start=1
    args+=(--highlight-line "$line" --line-range "$start:")
  fi

  bat "${args[@]}" "$file"
  exit 0
fi

# 一覧のカラムは path:line:text。--column は付けない。桁は preview で使わず、
# フィールドが 1 つ増えるだけになる。
#
# 空クエリでは何も出さない。rg は空パターンを全行マッチとして扱うので、
# 切り替えた直後に repo 全体が流れ込む。
#
# 最後に exit 0 を置く。rg は該当なしで 1 を返し、そのまま fzf の reload に
# 渡すと失敗として扱われる余地がある。空の一覧はエラーではない。
if [[ "${1:-}" == "--grep" ]]; then
  [[ -n "${2:-}" ]] || exit 0
  rg --line-number --no-heading --color=always --smart-case \
    --hidden --glob '!.git' -- "$2"
  exit 0
fi

# popup の cwd は呼び出し元と同じだが、明示されている方を優先する。
# `@` は session の cwd 基準で解決されるので、相対パスを渡す必要がある。
cd "${HERDR_ACTIVE_PANE_CWD:-$PWD}" || exit 1

# --- picker ------------------------------------------------------------------
# fd も rg も .gitignore を尊重する。.git だけは中身が邪魔なので明示的に外す。
#
# mode は prompt が持つ。C-t の transform で $FZF_PROMPT を読み、次の行き先を
# 決める。resume の scope 切替と同じ形で、スクリプト側に状態を置かない。
#
# change は最初に unbind する。rebind は一度 bind した key しか戻せないので、
# 宣言だけ先に済ませ、start で外しておく。@file の間に打鍵ごとの reload が
# 走ると、fzf 自前の絞り込みと二重になる。
#
# 切替の順序に意味がある。rg へ移るときは clear-query を rebind より前に置く。
# 逆向きは unbind を clear-query より前に置く。どちらも query の変化で
# 意図しない reload を呼ばないため。
#
# キー案内は footer に置く。lazygit と同じ位置で、prompt と一覧の領域を
# 削らない。出すのは現在地ではなく次の行き先。
selected=$("${FD_CMD[@]}" 2>/dev/null | fzf \
  --ansi --multi \
  --height=100% --reverse --prompt='@file> ' \
  --footer='C-t → rg' \
  --preview="'$SELF' --preview {}" \
  --preview-window='right:50%' \
  --bind="change:reload('$SELF' --grep {q})" \
  --bind='start:unbind(change)' \
  --bind="ctrl-t:transform:
    if [[ \$FZF_PROMPT == @file* ]]; then
      echo 'change-prompt(rg> )+change-footer(C-t → @file)+clear-query+disable-search+rebind(change)+reload(true)'
    else
      echo 'change-prompt(@file> )+change-footer(C-t → rg)+unbind(change)+enable-search+clear-query+reload(${FD_CMD[*]})'
    fi")

[[ -n "$selected" ]] || exit 0

# rg の行から path を抜く。`:<数字>:` を含む行だけ削るので、path に `:` を
# 持つファイルを @file 側で選んでも壊れない。同じファイルは先に出た方を残す。
# 複数選択は空白で繋ぐ。末尾にも空白を置き、続けて書き始められる状態にする。
mention=$(printf '%s\n' "$selected" \
  | sed -E 's/^(.+):[0-9]+:.*$/\1/' \
  | awk '!seen[$0]++' \
  | sed 's/^/@/' | tr '\n' ' ')

if [[ "${1:-}" != "--send" ]]; then
  echo "$mention"
  exit 0
fi

# 宛先。popup の中では HERDR_PANE_ID は無く、呼び出し元が
# HERDR_ACTIVE_PANE_ID に入る。pane で直接動かした場合は HERDR_PANE_ID を使う。
origin="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
[[ -n "$origin" ]] || { echo "claude-mention: 呼び出し元の pane を特定できない" >&2; exit 1; }

herdr pane send-text "$origin" "$mention"
