# Hunk session-diff Implementation Plan

> [!NOTE]
> 前 revision (base ファイル + `/session-diff` slash command) は放棄した。
> `/exit` → 再起動で base が上書きされる欠陥が構造的に避けられなかった。
> 判断の経緯は commit history を参照。

Goal: Claude Code の session 開始と同時に、herdr の現 pane を右に split し、そこで `hunk diff <HEAD-at-start> --watch` を起動する。
起動時の HEAD SHA は hunk プロセス自身が凍結するので、以降 commit しても branch を切り替えても session を再起動しても、hunk の表示は session 開始時点からの累積 diff を保ち続ける。

Architecture: SessionStart hook が herdr の socket API を叩いて focused pane を split し、そこで hunk を起動する。
共有ファイルや slash command は持たない。
状態は hunk プロセス 1 つに閉じる。

Tech Stack: bash, Claude Code SessionStart hook, herdr CLI (`herdr pane split`, `herdr pane run`), hunk (`hunk diff <ref> --watch`)。

## Global Constraints

- hook 本体は `dot-claude/hooks/` に置く (memory rule: feedback-claude-hooks-location)
- `settings.json` には呼び出しだけ書く
- 独自 DECISIONS.md や CLAUDE.md 追記は作らない (memory rule: feedback-no-dotfiles-decisions)
- 実体は `~/ghq/github.com/yasainet/dotfiles/dot-claude/...`
- symlink 先は `~/.claude/...`
- hook は `HERDR_ENV=1` のときだけ動く。herdr 外の Claude Code では no-op
- hook は SessionStart で `source == "startup"` のときだけ発火する
- `resume` と `clear` では pane を作らない
- git repo 外では pane を作らない
- direction は right (hunk の diff 表示に横幅が要るため)
- 2 pane 目以降の重複は当面許容する (Phase 2 で判断)

## File Structure

Create:

- `dot-claude/hooks/spawn-hunk-pane.sh` — SessionStart hook 本体

Modify:

- `dot-claude/settings.json` — SessionStart hooks 配列に呼び出しを追加

## Task 1: SessionStart hook で hunk pane を spawn する

Files:

- Create: `dot-claude/hooks/spawn-hunk-pane.sh`
- Modify: `dot-claude/settings.json`

Interfaces:

- Consumes: Claude Code SessionStart hook が stdin に渡す JSON
- 必要なフィールドは `source`
- 環境変数 `HERDR_ENV` を参照する
- Produces: 副作用として herdr の focused pane を split し、新規 pane で hunk を起動する
- 標準出力は使わない

- [ ] Step 1 — hook スクリプトを新規作成する

`dot-claude/hooks/spawn-hunk-pane.sh` に以下を書く。

```bash
#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Splits the current herdr pane to the right and runs
# `hunk diff <HEAD-at-start> --watch` so the session's cumulative
# diff is visible from the start.
set -euo pipefail

[[ "${HERDR_ENV:-}" == "1" ]] || exit 0

payload=$(cat)
source_kind=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"source"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)

if [[ "$source_kind" != "startup" && -n "$source_kind" ]]; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
[[ -n "$repo_root" ]] || exit 0

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
[[ -n "$head_sha" ]] || exit 0

current_pane=$(herdr pane list 2>/dev/null | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for pane in data.get("result", {}).get("panes", []):
    if pane.get("focused"):
        print(pane.get("pane_id", ""))
        break
' || true)
[[ -n "$current_pane" ]] || exit 0

split_resp=$(herdr pane split "$current_pane" --direction right --no-focus 2>/dev/null || true)
[[ -n "$split_resp" ]] || exit 0

new_pane=$(printf '%s' "$split_resp" | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
    print(data["result"]["pane"]["pane_id"])
except Exception:
    pass
' || true)
[[ -n "$new_pane" ]] || exit 0

herdr pane run "$new_pane" "cd '$repo_root' && hunk diff $head_sha --watch"
```

実行権限を付ける。

```bash
chmod +x ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh
```

- [ ] Step 2 — `settings.json` に hook を配線する

`hooks.SessionStart[0].hooks` 配列の末尾に以下を追加する。

```json
{
  "type": "command",
  "command": "bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh",
  "timeout": 5
}
```

- [ ] Step 3 — no-op 分岐を検証する

以下を実行する。

```bash
# HERDR_ENV なし
env -u HERDR_ENV bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh <<< '{"source":"startup"}'
echo "no HERDR_ENV: exit=$?"

# resume
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh <<< '{"source":"resume"}'
echo "resume: exit=$?"

# clear
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh <<< '{"source":"clear"}'
echo "clear: exit=$?"

# git 外
cd /tmp && HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh <<< '{"source":"startup"}'
echo "no git: exit=$?"
```

期待: いずれも `exit=0`、pane 数変化なし。

- [ ] Step 4 — startup で pane が split して hunk が起動することを確認する

以下を実行する。

```bash
HERDR_ENV=1 bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/spawn-hunk-pane.sh <<< '{"source":"startup"}'
```

期待: 現 pane が右に split する。
右側の新 pane で `hunk diff <SHA> --watch` が走る。
表示は session 開始時点の HEAD からの diff。

このステップは目視確認項目とする。

- [ ] Step 5 — commit する

```bash
git add dot-claude/hooks/spawn-hunk-pane.sh dot-claude/settings.json
git commit -m "add(claude): SessionStart hook で hunk pane を herdr に spawn"
```

## Verification

以下がすべて成立したら完了とする。

- [ ] 新規 Claude Code session を開始すると、現 pane が右に split して hunk が立ち上がる
- [ ] `/clear` や `--resume` では pane が作られない
- [ ] git repo 外の session では pane が作られない
- [ ] herdr 外 (直接ターミナル起動) の Claude Code では pane が作られない
- [ ] 生えた hunk pane は session 途中で commit しても表示を維持する
- [ ] session を `/exit` しても hunk pane は残る (単独プロセスなので)

## Phase 2 判断のための観測ポイント

以下を体感して次の改善判断材料にする。

- 同じ repo で複数回 startup した時の pane 重複がどれだけ邪魔になるか
- 相談だけの session で pane が生えるのが邪魔かどうか
- `git rev-parse HEAD` が空の repo (最初の commit 前) での挙動が問題になるか
- worktree 経由の session (`GIT_DIR != GIT_COMMON`) での挙動が問題になるか
- direction=right の代わりに down のほうが実用的か

上記が Phase 2 (重複防止、lazy 起動、worktree 対応、direction 選択肢) の判断材料になる。
Phase 1 の段階では対策を先取りしない。
