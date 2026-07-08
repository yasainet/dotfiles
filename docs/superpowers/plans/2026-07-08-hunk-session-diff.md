# Hunk session-diff Implementation Plan

> [!NOTE]
> 前 revision (base ファイル + `/session-diff` slash command) は放棄した。
> `/exit` → 再起動で base が上書きされる欠陥が構造的に避けられなかった。
> 判断の経緯は commit history を参照。

Goal: Claude Code の session 開始と同時に、herdr の新規 tab で `hunk diff <HEAD-at-start> --watch` を起動する。
起動時の HEAD SHA は hunk プロセス自身が凍結するので、以降 commit しても branch を切り替えても session を再起動しても、hunk の表示は session 開始時点からの累積 diff を保ち続ける。

Architecture: SessionStart hook が herdr の socket API を叩いて新規 tab を作り、そこで hunk を起動する。
共有ファイルや slash command は持たない。
状態は hunk プロセス 1 つに閉じる。

Tech Stack: bash, Claude Code SessionStart hook, herdr CLI (`herdr tab create`, `herdr pane run`), hunk (`hunk diff <ref> --watch`)。

## Global Constraints

- hook 本体は `dot-claude/hooks/` に置く (memory rule: feedback-claude-hooks-location)
- `settings.json` には呼び出しだけ書く
- 独自 DECISIONS.md や CLAUDE.md 追記は作らない (memory rule: feedback-no-dotfiles-decisions)
- 実体は `~/ghq/github.com/yasainet/dotfiles/dot-claude/...`
- symlink 先は `~/.claude/...`
- hook は `HERDR_ENV=1` のときだけ動く。herdr 外の Claude Code では no-op
- hook は SessionStart で `source == "startup"` のときだけ発火する
- `resume` と `clear` では tab を作らない
- git repo 外では tab を作らない
- 2 tab 目以降の重複は当面許容する (Phase 2 で判断)

## File Structure

Create:

- `dot-claude/hooks/spawn-hunk-tab.sh` — SessionStart hook 本体

Delete:

- `dot-claude/hooks/session-base-record.sh` — 前 revision の hook
- `dot-claude/scripts/session-diff.sh` — 前 revision の slash command 実装
- `dot-claude/commands/session-diff.md` — 前 revision の slash command 定義

Modify:

- `dot-claude/settings.json` — SessionStart hooks 配列を差し替え
- 具体的には `session-base-record.sh` の呼び出しを `spawn-hunk-tab.sh` に置換

## Task 1: 前 revision を撤去する

Files:

- Delete: `dot-claude/hooks/session-base-record.sh`
- Delete: `dot-claude/scripts/session-diff.sh`
- Delete: `dot-claude/commands/session-diff.md`
- Modify: `dot-claude/settings.json` (`session-base-record.sh` の hook エントリを削除)

- [ ] Step 1 — 3 ファイルを削除する

```bash
cd ~/ghq/github.com/yasainet/dotfiles
git rm dot-claude/hooks/session-base-record.sh
git rm dot-claude/scripts/session-diff.sh
git rm dot-claude/commands/session-diff.md
rmdir dot-claude/commands 2>/dev/null || true
```

- [ ] Step 2 — `settings.json` から旧 hook エントリを外す

`hooks.SessionStart[0].hooks` 配列から `session-base-record.sh` のエントリを削除する。
`herdr-agent-state.sh` は残す。

- [ ] Step 3 — 副産物を掃除する

`~/.claude/tmp/session-base/` は前 revision の base ファイル置き場だった。
残しても実害はないが、掃除する。

```bash
rm -rf ~/.claude/tmp/session-base
```

- [ ] Step 4 — commit する

```bash
git add -A dot-claude
git commit -m "revert(claude): base ファイル方式の /session-diff を撤去"
```

## Task 2: SessionStart hook で hunk tab を spawn する

Files:

- Create: `dot-claude/hooks/spawn-hunk-tab.sh`
- Modify: `dot-claude/settings.json` (新しい hook エントリを追加)

Interfaces:

- Consumes: Claude Code SessionStart hook が stdin に渡す JSON
- 必要なフィールドは `source`
- 環境変数 `HERDR_ENV` を参照する
- Produces: 副作用として herdr に新規 tab を作り hunk を起動する
- 標準出力は使わない (SessionStart hook は Claude 本体には見せない)

- [ ] Step 1 — hook スクリプトを新規作成する

`dot-claude/hooks/spawn-hunk-tab.sh` に以下を書く。

```bash
#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Opens a herdr tab that runs `hunk diff <HEAD-at-start> --watch`
# so the session's cumulative diff is visible from the start.
set -euo pipefail

# herdr 外では何もしない
[[ "${HERDR_ENV:-}" == "1" ]] || exit 0

payload=$(cat)
source_kind=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"source"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)

# resume と clear では tab を作らない
if [[ "$source_kind" != "startup" && -n "$source_kind" ]]; then
  exit 0
fi

# git repo 外では tab を作らない
repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
[[ -n "$repo_root" ]] || exit 0

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
[[ -n "$head_sha" ]] || exit 0

# 現在の workspace ID を取り出す
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

# 新規 tab を作る (focus は奪わない)
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

# hunk を起動 (repo に cd してから)
herdr pane run "$pane_id" "cd '$repo_root' && hunk diff $head_sha --watch"
```

実行権限を付ける。

```bash
chmod +x ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh
```

- [ ] Step 2 — `settings.json` に hook を配線する

`hooks.SessionStart[0].hooks` 配列の末尾に以下エントリを追加する。

```json
{
  "type": "command",
  "command": "bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh",
  "timeout": 5
}
```

- [ ] Step 3 — herdr 外での no-op を確認する

以下を実行する。

```bash
env -u HERDR_ENV bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh <<< '{"source":"startup"}'
echo "exit=$?"
```

期待: `exit=0`、herdr の状態変化なし。

- [ ] Step 4 — resume/clear で発火しないことを確認する

以下を実行する。

```bash
before=$(herdr tab list --workspace w1H 2>/dev/null | python3 -c 'import sys,json; print(len(json.load(sys.stdin)["result"]["tabs"]))')
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh <<< '{"source":"resume"}'
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh <<< '{"source":"clear"}'
after=$(herdr tab list --workspace w1H 2>/dev/null | python3 -c 'import sys,json; print(len(json.load(sys.stdin)["result"]["tabs"]))')
[[ "$before" == "$after" ]] && echo OK-no-new-tab || echo NG-new-tab-created
```

期待: `OK-no-new-tab`。

`w1H` の部分は自分の workspace ID で置き換える。

- [ ] Step 5 — startup で tab が生えて hunk が起動することを確認する

以下を実行する。

```bash
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-tab.sh <<< '{"source":"startup"}'
```

期待: 新規 tab が現れる。
tab の中で `hunk diff <SHA> --watch` が走る。
表示は session 開始時点の HEAD からの diff (working tree との差分)。

このステップは目視確認項目とする。
実行者は pass / fail を明示的に報告する。

- [ ] Step 6 — commit する

```bash
git add dot-claude/hooks/spawn-hunk-tab.sh dot-claude/settings.json
git commit -m "add(claude): SessionStart hook で hunk tab を herdr に spawn"
```

## Verification

以下がすべて成立したら完了とする。

- [ ] 新規 Claude Code session を開始すると、herdr の新規 tab に hunk が立ち上がる
- [ ] `/clear` や `--resume` では tab が作られない
- [ ] git repo 外の session では tab が作られない
- [ ] herdr 外 (直接ターミナル起動) の Claude Code では tab が作られない
- [ ] 生えた hunk tab は session 途中で commit しても表示を維持する
- [ ] session を `/exit` しても hunk tab は残る (単独プロセスなので)

## Phase 2 判断のための観測ポイント

以下を体感して次の改善判断材料にする。

- 同じ repo で複数回 startup した時の tab 重複がどれだけ邪魔になるか
- 相談だけの session で tab が生えるのが邪魔かどうか
- `git rev-parse HEAD` が空の repo (最初の commit 前) での挙動が問題になるか
- worktree 経由の session (`GIT_DIR != GIT_COMMON`) での挙動が問題になるか

上記が Phase 2 (重複防止、lazy 起動、worktree 対応) の判断材料になる。
Phase 1 の段階では対策を先取りしない。
