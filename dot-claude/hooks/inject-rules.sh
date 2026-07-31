#!/usr/bin/env bash
# PreToolUse(Write|Edit): path-scoped rule を書き込み前に注入する
#
# 本体の rule 機構は「マッチする file を Read tool で読んだとき」にしか発火しない。
# 新規作成には読む対象が無く、既存 file も Bash の head で覗くと素通りする。
# 規約が最も要るのは新規作成の瞬間なので、書き込み口を直接押さえる
#
# 同じ要望は本家 issue #38487 (と #23478 #27861 #36334) で closed as not planned。
# 本体で塞がる見込みが無いため自前で持つ
#
# Read 時は何もしない。本体と hook で glob 実装が違い、本体が拾えず hook だけが
# 拾う組み合わせがある。記録して注入を抑えると、その差が漏れになる。
# 二重注入は context を食うだけだが、漏れは規約違反を生む
#
# jq が無い等で落ちても書き込みは通す。注入は保険であって門番ではない
set -uf

# hook の出力文字列は 10,000 字上限。超えた分は捨てられるので手前で止める
LIMIT=9000

JQ=/opt/homebrew/bin/jq
[ -x "$JQ" ] || JQ=jq

IFS= read -rd '' input

# 入力が壊れていても transcript に parse error を残さない。素通りさせるだけ
path=$("$JQ" -r '.tool_input.file_path // ""' <<<"$input" 2> /dev/null)
[ -z "$path" ] && exit 0

# 同じ rule を session 内で二度送らない。session が終われば残骸だが、
# /tmp なので放っておいてよい
sid=$("$JQ" -r '.session_id // "nosession"' <<<"$input" 2> /dev/null)
sid=${sid:-nosession}
seen="${TMPDIR:-/tmp}/claude-injected-rules-$sid"
: >> "$seen" || exit 0

# frontmatter の paths だけを拾う。paths を持たない rule は常時 load 済みで対象外
read_paths() {
  awk '
    /^---[[:space:]]*$/ { n++; if (n >= 2) exit; next }
    n != 1 { next }
    /^paths:[[:space:]]*$/ { inp = 1; next }
    /^[^[:space:]-]/ { inp = 0 }
    inp && /^[[:space:]]*-[[:space:]]/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      gsub(/^["'"'"']|["'"'"']$/, "")
      if (length($0)) print
    }
  ' "$1"
}

dirs=("$HOME/.claude/rules")
[ -n "${CLAUDE_PROJECT_DIR:-}" ] && dirs+=("$CLAUDE_PROJECT_DIR/.claude/rules")

body=
truncated=

# user rule が先、project rule が後。本体の load 順に合わせる
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -qxF "$f" "$seen" && continue

  while IFS= read -r pat; do
    # bash の == は ** を * と同じに扱う。/ も跨ぐので実用上これで足りる。
    # 本体の glob より緩く、docs/**/*.md が docsX/a.md を拾う理論上の誤爆はある
    # shellcheck disable=SC2053
    [[ $path == $pat ]] || continue

    chunk=$(cat "$f")
    if [ "${#body}" -gt 0 ] && [ $((${#body} + ${#chunk})) -gt "$LIMIT" ]; then
      truncated=1
      break 2
    fi
    body+="# $f"$'\n'"$chunk"$'\n\n'
    printf '%s\n' "$f" >> "$seen"
    break
  done < <(read_paths "$f")
# -L で symlink を辿る。rules/ ごと dotfiles へ symlink している構成があり、
# 付けないと 1 件も拾えない
done < <(find -L "${dirs[@]}" -name '*.md' -type f 2>/dev/null | sort)

[ -z "$body" ] && exit 0

[ -n "$truncated" ] && body+=$'(以降の rule は 10,000 字上限のため省いた。必要なら ~/.claude/rules/ を読め)\n'

"$JQ" -n --arg c "$path に適用される rule。書き込み内容をこれに従わせよ。

$body" '{hookSpecificOutput:{hookEventName:"PreToolUse",additionalContext:$c}}'
