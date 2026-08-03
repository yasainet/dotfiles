#!/usr/bin/env bash
# 呼び出し元 pane で動いている Claude Code の session 分の diff を hunk で開く。
#
# auto mode の Claude は途中で commit してしまう。`hunk diff` は working tree
# しか見ないため、commit 済みの変更が視界から消える。session 開始時点の commit
# を base に取り直せば、commit 済みと未 commit を一枚の diff で追える。
#
# base の求め方は「session 開始時刻より前の最後の commit」。Claude Code の
# transcript は開始時の HEAD を持たないため、時刻から逆算する。SessionStart
# hook で sha を記録する手もあるが、それだと過去の session に遡って効かない。
#
# ただし時刻だけで切ると、同じ repo で並列に動く別 session の commit まで
# 範囲に入る。そこで transcript の file-history、つまり Claude が checkpoint
# 用に残す Write/Edit の記録を pathspec にして絞る。
#
# `git commit` の出力に残る `[main 92ab95e]` から sha を拾う案も試したが捨てた。
# transcript には他所の commit を書き写しただけの出力も載る。実際、別 session
# の記録を読んだ回の出力を拾って無関係な file が pathspec に混ざった。commit を
# 実行した tool_use に紐付けても、`grep "git commit"` のようなコマンドが同じ
# 網に掛かる。取りこぼし (Bash 経由の編集) より、他 session の変更が混ざる方が
# 害が大きい。混ざったら絞った意味が無い。
#
# 制約:
#   - `--resume` した session は transcript に追記されるため、base が初回
#     起動時まで遡る。session 全体の diff としては正しいが、想定より広い
#   - 並列 session が同じ file を触った場合は分離できない。git のデータ
#     モデル上、file 単位より細かくは切れない
#   - Bash で sed や mv した変更は file-history に残らず漏れる。全部見たい
#     ときは prefix+C-h の `hunk diff` を使う
set -uo pipefail

die() {
  printf 'hunk-session: %s\n' "$1" >&2
  # popup は exit した瞬間に閉じる。メッセージを読ませるために止める
  printf '\n何かキーを押すと閉じます' >&2
  read -rsn1
  exit 1
}

# popup の中では HERDR_PANE_ID は無く、呼び出し元が HERDR_ACTIVE_PANE_ID に入る。
# pane で直接動かした場合は HERDR_PANE_ID を使う。
origin="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
[[ -n "$origin" ]] || die "呼び出し元の pane を特定できない"

# agent list は pane_id と Claude の session id を紐付ける唯一の口。
# cwd も一緒に取る。popup の cwd が呼び出し元に追従する保証は無い。
read -r sid cwd < <(herdr agent list 2> /dev/null | jq -r --arg p "$origin" '
  .result.agents[]
  | select(.pane_id == $p and .agent == "claude")
  | [(.agent_session.value // ""), (.foreground_cwd // .cwd)]
  | @tsv
') || true

[[ -n "${sid:-}" ]] || die "この pane に Claude Code の session が無い"

cd "$cwd" 2> /dev/null || die "cwd に入れない: $cwd"
root=$(git rev-parse --show-toplevel 2> /dev/null) || die "git repo ではない: $cwd"

# transcript は ~/.claude/projects/<encoded-cwd>/<id>.jsonl。encode 規則に
# 依存したくないので glob で拾う。
file=""
for f in "$HOME"/.claude/projects/*/"$sid".jsonl; do
  [[ -f "$f" ]] && {
    file="$f"
    break
  }
done
[[ -n "$file" ]] || die "transcript が無い: $sid"

# 先頭行は type=mode 等で timestamp を持たないことがある。最初に見つかった
# timestamp を session 開始時刻とみなす。
ts=$(jq -r 'select(.timestamp) | .timestamp' "$file" 2> /dev/null | head -1)
[[ -n "$ts" ]] || die "session の開始時刻を読めない"

# committer date で絞る。session 開始前の最後の commit が base になる。
base=$(git rev-list -1 --before="$ts" HEAD 2> /dev/null)

# --- pathspec ---------------------------------------------------------------
# Write/Edit が触った file。scratchpad のような repo 外の絶対パスが混ざるので
# あとで root 配下だけに絞る。
paths=$(jq -r '
  (select(.type == "file-history-snapshot") | .snapshot.trackedFileBackups | keys[]?),
  (select(.type == "file-history-delta") | .trackingPath // empty)
' "$file" 2> /dev/null)

# root 配下に正規化する。相対パスは root 起点、絶対パスは root 配下のものだけ。
pathspec=()
while IFS= read -r p; do
  [[ -n "$p" ]] || continue
  case "$p" in
    "$root"/*) p="${p#"$root"/}" ;;
    /*) continue ;; # scratchpad など repo 外
  esac
  pathspec+=("$p")
done < <(printf '%s\n' "$paths" | sort -u)

# base が空になるのは session 開始前に commit が無い repo。
target=("${base:+$base}")

# 触った file が一つも取れない session（読むだけで終わった等）は、絞らずに
# 全体を見せる。空の pathspec を渡すと何も表示されず、事故に見える。
if [[ ${#pathspec[@]} -eq 0 ]]; then
  exec hunk diff "${target[@]}"
fi

exec hunk diff "${target[@]}" -- "${pathspec[@]}"
