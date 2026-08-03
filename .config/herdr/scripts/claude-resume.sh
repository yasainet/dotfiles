#!/usr/bin/env bash
# Claude Code の session を fzf で選ぶ。
#
# Claude Code の /resume は session を「最初の数十文字 + 経過時間」でしか
# 出さないため、どれがどれか判別しづらい。ここでは初回プロンプトを一覧に、
# 会話の user 発言全文を preview に出す。
#
# 一覧のデータ元は ~/.claude/history.jsonl。1 プロンプト 1 行で
# {display, timestamp, project, sessionId} を持つ。独自の index は作らない。
# preview は ~/.claude/projects/<cwd>/<id>.jsonl を読む。
#
# 引数なし   : 選んだ session を claude --resume で開く (端末から直接使う)
# --send     : 呼び出し元 pane の prompt 欄に `/resume <id>` を差し込む。
#              herdr の popup keybind から使う経路。新しい claude を起動せず、
#              いまの session がその場で切り替わる。Enter は人間が押す。
# --preview  : fzf が内部で呼ぶ。単体で使うものではない。
set -uo pipefail

# fzf は preview のために自分を呼び直す。相対パスだと cwd 次第で外すので畳む。
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

# --- preview -----------------------------------------------------------------
# transcript を会話として繋ぎ、markdown として色を付ける。
# prompt はそのまま、回答は引用にして視覚的に一段下げる。探すときの手がかりは
# 自分が何を訊いたかなので、回答が prompt を埋めないようにする。
#
# 落とすもの:
#   isMeta      skill 定義や system reminder の注入。人間が書いたものではない
#   isSidechain subagent の会話
#   thinking    思考ブロック。別 entry で来る
#   tool_use    tool 呼び出し。同上
#   tool_result content 配列に混ざる tool の返り値
if [[ "${1:-}" == "--preview" ]]; then
  id="${2:-}"
  [[ -n "$id" ]] || exit 0

  file=""
  for f in "$HOME"/.claude/projects/*/"$id".jsonl; do
    [[ -f "$f" ]] && { file="$f"; break; }
  done
  [[ -n "$file" ]] || exit 0

  jq -sr '
    map(
      select(.type == "user" or .type == "assistant")
      | select((.isMeta // false) | not)
      | select((.isSidechain // false) | not)
      | {
          role: .type,
          text: (.message.content
                 | if type == "string" then .
                   else (map(select(.type == "text").text) | join("")) end)
        }
    )
    | map(select(.text | length > 0))
    | to_entries
    | map(
        if .value.role == "assistant"
        then (.value.text | split("\n") | map(if . == "" then ">" else "> " + . end) | join("\n"))
        else (if .key > 0 then "---\n\n" else "" end) + .value.text
        end
      )
    | join("\n\n")
  ' "$file" | bat \
    --language md --color=always --style=plain --paging=never \
    --terminal-width="${FZF_PREVIEW_COLUMNS:-80}"
  exit 0
fi

# --- picker ------------------------------------------------------------------
HISTORY="$HOME/.claude/history.jsonl"
[[ -f "$HISTORY" ]] || { echo "claude-resume: $HISTORY がない" >&2; exit 1; }

root=$(git rev-parse --show-toplevel 2>/dev/null) || root="$PWD"

# session ごとに集約する。最終更新でソートし、初回プロンプトを見出しにする。
# `/resume` のような slash command 一発で終わった session は除く。
selected=$(jq -sr --arg root "$root" '
  map(select(.project == $root or (.project | startswith($root + "/"))))
  | group_by(.sessionId)
  | map({
      id:    .[0].sessionId,
      t:     (map(.timestamp) | max),
      n:     length,
      first: (.[0].display | split("\n") | map(select(. != "")) | first // "(empty)")
    })
  | map(select(.n > 1 or (.first | startswith("/") | not)))
  | sort_by(-.t)
  | .[]
  | [.id, (.t / 1000 | strflocaltime("%m-%d %H:%M")), "[\(.n)]", .first] | @tsv
' "$HISTORY" | fzf \
  --delimiter='\t' --with-nth='2..' \
  --height=100% --reverse --prompt='Session> ' \
  --preview="'$SELF' --preview {1}" \
  --preview-window='right:55%:wrap')

id="${selected%%$'\t'*}"
[[ -n "$id" ]] || exit 0

if [[ "${1:-}" != "--send" ]]; then
  exec claude --resume "$id"
fi

# 宛先。popup の中では HERDR_PANE_ID は無く、呼び出し元が
# HERDR_ACTIVE_PANE_ID に入る。pane で直接動かした場合は HERDR_PANE_ID を使う。
origin="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
[[ -n "$origin" ]] || { echo "claude-resume: 呼び出し元の pane を特定できない" >&2; exit 1; }

herdr pane send-text "$origin" "/resume $id"
