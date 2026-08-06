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
# 一覧の範囲は fzf の中で C-t で切り替える。いまの repo と全 repo を往復する。
# git root は worktree ごとに別パスなので、repo スコープは worktree 単位の
# 絞り込みも兼ねる。
#
# 引数なし   : 選んだ session を claude --resume で開く (端末から直接使う)
# --send     : 呼び出し元 pane の prompt 欄に `/resume <id>` を差し込む。
#              herdr の popup keybind から使う経路。新しい claude を起動せず、
#              いまの session がその場で切り替わる。Enter は人間が押す。
# --list     : fzf が reload で呼ぶ。単体で使うものではない。
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

HISTORY="$HOME/.claude/history.jsonl"

# --- list --------------------------------------------------------------------
# session ごとに集約する。最終更新でソートし、初回プロンプトを見出しにする。
# `/resume` のような slash command 一発で終わった session は除く。
#
# all のときだけ repo 名のカラムを足す。カラム数が変わっても fzf の
# --with-nth='2..' は追随するので、fzf 側に分岐は要らない。tab は桁を
# 揃えないので、repo 名は jq の側で最長に合わせて詰める。
#
# repo 名は ghq の <host>/<owner>/<repo> から拾う。末尾 2 階層を取ると
# repo の中で起動した session が別物として並ぶ。Claude Code の worktree は
# .claude/worktrees/<name> に作られるので、そのまま出しても持ち主が
# 分からないうえ、開発が終われば消える名前が居座る。
#
# 発言数は出さない。session の長短は選ぶ手がかりにならず、桁が揺れて
# 後続のカラムをずらすわりに、本文の幅を食う。
if [[ "${1:-}" == "--list" ]]; then
  [[ -f "$HISTORY" ]] || { echo "claude-resume: $HISTORY がない" >&2; exit 1; }

  if [[ "${2:-repo}" == "all" ]]; then
    root=""
  else
    root=$(git rev-parse --show-toplevel 2>/dev/null) || root="$PWD"
  fi

  jq -sr --arg root "$root" '
    map(select($root == "" or .project == $root
               or (.project | startswith($root + "/"))))
    | group_by(.sessionId)
    | map({
        id:    .[0].sessionId,
        t:     (map(.timestamp) | max),
        n:     length,
        repo:  (.[0].project as $p
                | ($p | capture("/ghq/[^/]+/(?<o>[^/]+)/(?<r>[^/]+)") | "\(.o)/\(.r)")
                  // ($p | split("/") | last)),
        first: (.[0].display | split("\n") | map(select(. != "")) | first // "(empty)")
      })
    | map(select(.n > 1 or (.first | startswith("/") | not)))
    | sort_by(-.t)
    | (map(.repo | length) | max // 0) as $w
    | .[]
    | [.id, (.t / 1000 | strflocaltime("%m-%d %H:%M"))]
      + (if $root == "" then [.repo + (" " * ($w - (.repo | length) + 1))] else [] end)
      + [.first]
    | @tsv
  ' "$HISTORY"
  exit 0
fi

# --- picker ------------------------------------------------------------------
# C-t 1 つで往復させる。scope を 2 つのキーに割ると片方が C-a になり、fzf の
# 既定 (入力欄の行頭へ移動) を潰す。いまの scope は prompt が持っているので、
# transform で $FZF_PROMPT を読んで次の行き先を決める。
#
# キーは claude-mention の mode 切替と揃える。切り替えるものは scope と mode で
# 違うが、押す側から見れば「一覧の対象を変える」1 つの操作でしかない。C-t は
# fzf の既定が使っていない。
#
# キー案内は footer に置く。lazygit と同じ位置で、prompt と一覧の領域を
# 削らない。出すのは現在地ではなく次の行き先。現在地は prompt が既に
# 言っているので、重ねても案内にならない。
#
# tabstop を 1 にする。既定の 8 だと区切りの tab が次の 8 桁まで飛び、桁を
# 揃える仕組みが jq のパディングと二重にかかって本文の幅を食う。揃えるのは
# jq の側だけにする。
#
# hscroll は切る。既定では match した位置を見せるために行が左へ流れ、その行
# だけ日時と repo が押し出される。当たった箇所は preview で読めるので、桁が
# 揃っている方を取る。
selected=$("$SELF" --list repo | fzf \
  --delimiter='\t' --with-nth='2..' --tabstop=1 --no-hscroll \
  --height=100% --reverse --prompt='Repo> ' \
  --footer='C-t → All' \
  --preview="'$SELF' --preview {1}" \
  --preview-window='right:50%:wrap' \
  --bind="ctrl-t:transform:
    if [[ \$FZF_PROMPT == Repo* ]]; then
      echo 'change-prompt(All> )+change-footer(C-t → Repo)+reload(\"$SELF\" --list all)'
    else
      echo 'change-prompt(Repo> )+change-footer(C-t → All)+reload(\"$SELF\" --list repo)'
    fi")

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
