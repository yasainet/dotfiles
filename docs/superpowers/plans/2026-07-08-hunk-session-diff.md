# Hunk session-diff Implementation Plan

> [!NOTE]
> 経緯: base ファイル方式 → SessionStart で hunk tab spawn → 本 revision (lazy PreToolUse) と 3 段階で進化した。
> 判断の詳細は commit history 参照。

Goal: Claude Code の session で初めて Edit / Write / NotebookEdit が発火した瞬間、herdr の新規 tab で `hunk diff <HEAD-at-first-edit> --watch` を起動する。
起動時の HEAD SHA は hunk プロセス自身が凍結するので、以降 commit しても branch を切り替えても session を再起動しても、hunk の表示は「編集開始点」からの累積 diff を保ち続ける。

Architecture: PreToolUse hook が session_id 単位の sentinel ファイルで初回判定を行い、初回のみ herdr の socket API で新規 tab を作って hunk を起動する。
相談だけの session では tab が生えない。

Tech Stack: bash, Claude Code PreToolUse hook, herdr CLI (`herdr tab create`, `herdr pane run`), hunk (`hunk diff <ref> --watch`)。

## Global Constraints

- hook 本体は `dot-claude/hooks/` に置く (memory rule: feedback-claude-hooks-location)
- `settings.json` には呼び出しだけ書く
- 独自 DECISIONS.md や CLAUDE.md 追記は作らない (memory rule: feedback-no-dotfiles-decisions)
- 実体は `~/ghq/github.com/yasainet/dotfiles/dot-claude/...`
- symlink 先は `~/.claude/...`
- hook は `HERDR_ENV=1` のときだけ動く
- hook は PreToolUse で Edit / Write / NotebookEdit のいずれかにマッチした時に発火する
- Bash / Skill / Task などは対象外 (ノイズ回避)
- session_id 単位で 1 回だけ発火する
- sentinel 格納先: `~/.claude/tmp/hunk-spawned/<session_id>` (空ファイル)
- sentinel 掃除は行わない (数バイト × session 数、実害ゼロ)
- git repo 外では tab を作らない
- 2 tab 目以降の重複は当面許容する (Phase 3 で判断)

## File Structure

Modify:

- `dot-claude/hooks/spawn-hunk-on-first-edit.sh` — 前 revision の `spawn-hunk-tab.sh` を rename + 中身刷新
- `dot-claude/settings.json` — SessionStart から PreToolUse へ配線を移動

## Task 1: SessionStart hook を lazy PreToolUse に置き換える

Files:

- Rename: `dot-claude/hooks/spawn-hunk-tab.sh` → `dot-claude/hooks/spawn-hunk-on-first-edit.sh`
- Modify: 上記 hook スクリプトの中身
- Modify: `dot-claude/settings.json`

Interfaces:

- Consumes: Claude Code PreToolUse hook が stdin に渡す JSON
- 必要なフィールドは `session_id`
- 環境変数 `HERDR_ENV` を参照する
- Produces: 副作用として `~/.claude/tmp/hunk-spawned/<session_id>` を作成する
- 副作用として herdr に新規 tab を作り hunk を起動する (初回のみ)
- 標準出力は使わない

- [ ] Step 1 — hook ファイルを rename する

```bash
cd ~/ghq/github.com/yasainet/dotfiles
git mv dot-claude/hooks/spawn-hunk-tab.sh dot-claude/hooks/spawn-hunk-on-first-edit.sh
```

- [ ] Step 2 — hook 本体を書き換える

`dot-claude/hooks/spawn-hunk-on-first-edit.sh` の中身を以下に差し替える。

```bash
#!/usr/bin/env bash
# Claude Code PreToolUse hook (Edit / Write / NotebookEdit).
# On the first file-mutating tool call of a session, opens a herdr tab
# running `hunk diff <HEAD-at-first-edit> --watch` so the session's
# cumulative diff is visible from the moment editing begins.
# Subsequent tool calls in the same session are no-op.
set -euo pipefail

[[ "${HERDR_ENV:-}" == "1" ]] || exit 0

payload=$(cat)

session_id=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)
[[ -n "$session_id" ]] || exit 0

sentinel_dir="$HOME/.claude/tmp/hunk-spawned"
mkdir -p "$sentinel_dir"
sentinel="$sentinel_dir/$session_id"

if ! (set -o noclobber; : > "$sentinel") 2>/dev/null; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
[[ -n "$repo_root" ]] || exit 0

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
[[ -n "$head_sha" ]] || exit 0

ws_id=$(herdr pane list 2>/dev/null | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for pane in data.get("result", {}).get("panes", []):
    if pane.get("focused"):
        print(pane.get("workspace_id", ""))
        break
' || true)
[[ -n "$ws_id" ]] || exit 0

tab_resp=$(herdr tab create --workspace "$ws_id" --label "hunk" --no-focus 2>/dev/null || true)
[[ -n "$tab_resp" ]] || exit 0

pane_id=$(printf '%s' "$tab_resp" | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
    print(data["result"]["root_pane"]["pane_id"])
except Exception:
    pass
' || true)
[[ -n "$pane_id" ]] || exit 0

herdr pane run "$pane_id" "cd '$repo_root' && hunk diff $head_sha --watch"
```

sentinel の atomic check-and-set は `set -o noclobber` + redirect の失敗で判定している。
既に sentinel があれば redirect が失敗して `exit 0`、無ければ空ファイルが作られて処理継続する。

- [ ] Step 3 — `settings.json` を書き換える

`hooks.SessionStart[0].hooks` から `spawn-hunk-tab.sh` エントリを削除する。
代わりに `hooks.PreToolUse` 配列末尾に以下エントリを追加する。

```json
{
  "matcher": "Edit|Write|NotebookEdit",
  "hooks": [
    {
      "type": "command",
      "command": "bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh",
      "timeout": 5
    }
  ]
}
```

matcher が regex を受け付けない場合は 3 エントリに分割する。
現時点では regex 前提で書く。

- [ ] Step 4 — no-op 分岐を検証する

以下を実行する。

```bash
# HERDR_ENV なし
env -u HERDR_ENV bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh <<< '{"session_id":"test-A","tool_name":"Edit"}'
echo "no HERDR_ENV: exit=$?"

# session_id なし
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh <<< '{"tool_name":"Edit"}'
echo "no session_id: exit=$?"
```

期待: いずれも `exit=0`、tab / sentinel 数変化なし。

- [ ] Step 5 — 初回発火と idempotency を検証する

以下を実行する。

```bash
rm -rf ~/.claude/tmp/hunk-spawned

# 1st call
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh <<< '{"session_id":"test-A","tool_name":"Edit"}'
echo "1st: exit=$?"

# 2nd call, same session_id
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh <<< '{"session_id":"test-A","tool_name":"Write"}'
echo "2nd: exit=$?"

# 3rd call, different session_id
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-on-first-edit.sh <<< '{"session_id":"test-B","tool_name":"Edit"}'
echo "3rd: exit=$?"

ls ~/.claude/tmp/hunk-spawned/
```

期待: 1st と 3rd で hunk tab が生える。
2nd では生えない。
sentinel は `test-A` と `test-B` の 2 つ。

このステップは目視確認項目とする。

- [ ] Step 6 — commit する

```bash
git add dot-claude/hooks/spawn-hunk-on-first-edit.sh dot-claude/settings.json
git commit -m "change(claude): SessionStart hook を lazy PreToolUse に置き換え"
```

## Verification

以下がすべて成立したら完了とする。

- [ ] 相談だけの session (Edit / Write / NotebookEdit なし) では tab が作られない
- [ ] 実装 session の最初の Edit / Write / NotebookEdit で tab が生えて hunk が起動する
- [ ] 同じ session 内の 2 回目以降の Edit / Write / NotebookEdit では tab が生えない
- [ ] Bash による git commit や sed -i では tab が生えない
- [ ] herdr 外の Claude Code では tab が作られない
- [ ] 生えた hunk tab は session 途中で commit しても表示を維持する
- [ ] session を `/exit` しても hunk tab は残る

## Phase 3 判断のための観測ポイント

以下を体感して次の改善判断材料にする。

- session_id 単位の sentinel でも「同じ repo 複数 session」の tab 重複が起きる
- その重複がどれだけ邪魔になるか
- Bash 経由の編集がメインの session (稀) で「tab が生えなくて困った」ケースがあるか
- sentinel ディレクトリの累積サイズが気になるかどうか
- worktree 経由の session での挙動が問題になるか

上記が Phase 3 (repo 単位 sentinel、Bash マッチ追加、sentinel TTL、worktree 対応) の判断材料になる。
