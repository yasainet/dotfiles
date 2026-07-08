# Hunk session-diff Implementation Plan

> [!NOTE]
> For agentic workers: REQUIRED SUB-SKILL は superpowers:subagent-driven-development (推奨) か superpowers:executing-plans。
> Steps は `- [ ]` タスクリスト記法で追跡する。

Goal: Claude Code の session 開始時点の HEAD SHA を記録する。
`/session-diff` で session 全体の累積 diff を hunk に開けるようにする。
累積 diff は複数 commit と未 commit 変更を合わせたもの。

Architecture: SessionStart hook が repo ごとに 1 ファイルへ base SHA を書く。
slash command `/session-diff` は helper script を叩くだけ。
script は hunk session が生きていれば `hunk session reload -- diff <base>` を発行する。
無ければユーザーが別窓で叩く用のコマンドを印字する。

Tech Stack: bash, Claude Code hooks / slash commands, hunk (`hunk session *` CLI), shasum。

## Global Constraints

- hook 本体は `dot-claude/hooks/` に置く
- `settings.json` には呼び出しだけ書く (memory rule: feedback-claude-hooks-location)
- 独自 DECISIONS.md や CLAUDE.md 追記は作らない (memory rule: feedback-no-dotfiles-decisions)
- 判断は commit message に集約する
- `dot-claude/` 配下は既存の symlink 運用に従う
- 実体は `~/ghq/github.com/yasainet/dotfiles/dot-claude/...`
- symlink 先は `~/.claude/...`
- macOS primary、Linux secondary。両方で動く `shasum -a 256` を使う
- hook は SessionStart で `source == "startup"` の時だけ base を上書きする
- `resume` と `clear` では既存 base を保持する
- 記録先は `~/.claude/tmp/session-base/<repo-hash>`
- `<repo-hash>` は repo top-level path の shasum 先頭 16 桁
- Phase 1 は「動作最小」構成
- lazy 記録 (PreToolUse) や session_id 単位管理は Phase 2 の判断材料集めのため実装しない

## File Structure

Create:

- `dot-claude/hooks/session-base-record.sh` — SessionStart hook 本体
- `dot-claude/scripts/session-diff.sh` — `/session-diff` の実装
- `dot-claude/commands/session-diff.md` — Claude Code slash command 定義

Modify:

- `dot-claude/settings.json` — SessionStart hooks 配列にエントリを 1 つ追加

## Task 1: Base SHA を SessionStart hook で記録

Files:

- Create: `dot-claude/hooks/session-base-record.sh`
- Modify: `dot-claude/settings.json` (`hooks.SessionStart[0].hooks` に 1 エントリ追加)

Interfaces:

- Consumes: Claude Code SessionStart hook が stdin へ渡す JSON
- JSON は少なくとも `source` フィールドを含む
- `source` の値は `startup` / `resume` / `clear` のいずれか
- Produces: `~/.claude/tmp/session-base/<repo-hash>` にテキストファイル
- 内容は 40 桁 git SHA と改行 1 個
- `<repo-hash>` の算出は `printf '%s' "$(git rev-parse --show-toplevel)" | shasum -a 256 | cut -c1-16`

- [ ] Step 1 — hook スクリプトを新規作成する

`dot-claude/hooks/session-base-record.sh` に以下を書く。

```bash
#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Records HEAD SHA at session startup so /session-diff can show cumulative diff.
set -euo pipefail

payload=$(cat)
source_kind=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"source"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)

if [[ "$source_kind" != "startup" && -n "$source_kind" ]]; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$repo_root" ]]; then
  exit 0
fi

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
if [[ -z "$head_sha" ]]; then
  exit 0
fi

repo_hash=$(printf '%s' "$repo_root" | shasum -a 256 | cut -c1-16)
base_dir="$HOME/.claude/tmp/session-base"
mkdir -p "$base_dir"
printf '%s\n' "$head_sha" > "$base_dir/$repo_hash"
```

実行権限を付ける。

```bash
chmod +x ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/session-base-record.sh
```

- [ ] Step 2 — hook 未実行の状態を確認する (RED)

以下を実行する。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
repo_hash=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -c1-16)
rm -f "$HOME/.claude/tmp/session-base/$repo_hash"
ls "$HOME/.claude/tmp/session-base/$repo_hash" 2>&1
```

期待: `No such file or directory` が返る。

- [ ] Step 3 — startup で HEAD が記録されることを確認する (GREEN)

以下を実行する。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
printf '{"source":"startup","session_id":"test-1"}' \
  | bash ./dot-claude/hooks/session-base-record.sh
repo_hash=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -c1-16)
cat "$HOME/.claude/tmp/session-base/$repo_hash"
```

期待: 40 桁 SHA 1 行が出力される。
現在の `git rev-parse HEAD` と一致すること。

- [ ] Step 4 — resume と clear で上書きしないことを確認する

以下を実行する。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
repo_hash=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -c1-16)
saved=$(cat "$HOME/.claude/tmp/session-base/$repo_hash")

printf '{"source":"resume","session_id":"test-2"}' \
  | bash ./dot-claude/hooks/session-base-record.sh
after=$(cat "$HOME/.claude/tmp/session-base/$repo_hash")
[[ "$saved" == "$after" ]] && echo OK-resume || echo NG-resume

printf '{"source":"clear","session_id":"test-3"}' \
  | bash ./dot-claude/hooks/session-base-record.sh
after=$(cat "$HOME/.claude/tmp/session-base/$repo_hash")
[[ "$saved" == "$after" ]] && echo OK-clear || echo NG-clear
```

期待: `OK-resume` と `OK-clear` が両方出る。

- [ ] Step 5 — git 外で叩いても壊れないことを確認する

以下を実行する。

```bash
cd /tmp
printf '{"source":"startup"}' \
  | bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/session-base-record.sh
echo "exit=$?"
```

期待: `exit=0` が出る。
新規ファイルは作られない。

- [ ] Step 6 — `dot-claude/settings.json` に hook を配線する

`hooks.SessionStart[0].hooks` 配列の末尾に以下エントリを追加する。
既存の `herdr-agent-state.sh` エントリの直後に置く。

```json
{
  "type": "command",
  "command": "bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/session-base-record.sh",
  "timeout": 5
}
```

- [ ] Step 7 — commit する

以下を実行する。

```bash
git add dot-claude/hooks/session-base-record.sh dot-claude/settings.json
git commit -m "add(claude): SessionStart hook で repo ごとの base SHA を記録"
```

## Task 2: `/session-diff` slash command で hunk に流す

Files:

- Create: `dot-claude/scripts/session-diff.sh`
- Create: `dot-claude/commands/session-diff.md`

Interfaces:

- Consumes: Task 1 が書いた `~/.claude/tmp/session-base/<repo-hash>` (40 桁 SHA)
- Produces: 標準出力に reload 報告か fallback コマンドの fenced block を出す

- [ ] Step 1 — helper script を新規作成する

`dot-claude/scripts/session-diff.sh` に以下を書く。

```bash
#!/usr/bin/env bash
# /session-diff の実装。session base に対する累積 diff を hunk で開く。
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$repo_root" ]]; then
  echo "not in a git repo. /session-diff needs a git repo." >&2
  exit 1
fi

repo_hash=$(printf '%s' "$repo_root" | shasum -a 256 | cut -c1-16)
base_file="$HOME/.claude/tmp/session-base/$repo_hash"
if [[ ! -f "$base_file" ]]; then
  echo "no session base recorded for $repo_root" >&2
  echo "restart Claude Code session to record one, or set manually:" >&2
  echo "  git rev-parse HEAD > $base_file" >&2
  exit 1
fi

base=$(cat "$base_file")

if hunk session get --repo "$repo_root" >/dev/null 2>&1; then
  hunk session reload --repo "$repo_root" -- diff "$base"
  echo "reloaded hunk session: diff $base"
else
  cat <<EOF
no live hunk session for this repo. run in another terminal:

    cd $repo_root
    hunk diff $base --watch
EOF
fi
```

実行権限を付ける。

```bash
chmod +x ~/ghq/github.com/yasainet/dotfiles/dot-claude/scripts/session-diff.sh
```

- [ ] Step 2 — base 未記録での挙動を確認する (RED)

以下を実行する。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
repo_hash=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -c1-16)
mv "$HOME/.claude/tmp/session-base/$repo_hash" \
   "$HOME/.claude/tmp/session-base/$repo_hash.bak" 2>/dev/null || true
bash ./dot-claude/scripts/session-diff.sh
echo "exit=$?"
```

期待: `no session base recorded ...` が stderr に出る。
`exit=1` が続く。

- [ ] Step 3 — hunk session なしでの fallback 印字を確認する (GREEN 前半)

以下を実行する。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
repo_hash=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -c1-16)
mv "$HOME/.claude/tmp/session-base/$repo_hash.bak" \
   "$HOME/.claude/tmp/session-base/$repo_hash" 2>/dev/null \
   || git rev-parse HEAD > "$HOME/.claude/tmp/session-base/$repo_hash"
hunk session list 2>&1 | head -3
bash ./dot-claude/scripts/session-diff.sh
```

期待: `no live hunk session ...` が出る。
`cd ...` と `hunk diff <SHA>` の 2 行が続いて印字される。

- [ ] Step 4 — hunk session ありでの reload を手動確認する (GREEN 後半)

別ターミナルで hunk TUI を立ち上げる。

```bash
cd ~/ghq/github.com/yasainet/dotfiles
hunk diff HEAD
```

元のシェルで以下を実行する。

```bash
bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/scripts/session-diff.sh
```

期待: `reloaded hunk session: diff <SHA>` が出る。
TUI 側の表示が base SHA からの diff に切り替わる。

このステップは目視確認項目とする。
実行者は pass / fail を明示的に報告する。

- [ ] Step 5 — slash command 定義を新規作成する

`dot-claude/commands/` が存在しない場合はディレクトリを作る。
`dot-claude/commands/session-diff.md` に以下を書く。

````markdown
---
description: session 開始時の HEAD からの累積 diff を hunk で開く
---

`~/ghq/github.com/yasainet/dotfiles/dot-claude/scripts/session-diff.sh` を Bash で実行してください。
標準出力と標準エラーの内容をそのまま提示してください。

- reload できた場合はその旨を 1 文で伝える
- fallback コマンドが印字された場合は fenced code block でそのまま示す
- ユーザーが別窓で叩けるように整形する
- git repo 外や base 未記録のエラーが返った場合はエラー本文と対処を淡々と伝える

対処は「session 再起動」または「手動 base 設定」を提示する。
追加の分析や解釈は不要。
スクリプトの出力を通す係に徹する。
````

- [ ] Step 6 — slash command が Claude Code に認識されることを確認する

Claude Code で新規 session を開始する。
`/session-diff` を入力する (実行はまだ不要)。

期待: 候補として補完に表示される。
または選択肢に出る。

実行時の確認は option とする。
実際に `/session-diff` を叩き、Task 1 で記録された base に対する diff が hunk へ流れることを確認する。
または fallback コマンドが提示されることを確認する。

- [ ] Step 7 — commit する

以下を実行する。

```bash
git add dot-claude/scripts/session-diff.sh dot-claude/commands/session-diff.md
git commit -m "add(claude): /session-diff コマンド、session 全体の累積 diff を hunk へ流す"
```

## Verification (Phase 1 完了時)

以下がすべて成立したら Phase 1 完了とする。

- [ ] 新規 Claude Code session を開始すると `~/.claude/tmp/session-base/<repo-hash>` が更新される
- [ ] `/clear` や `--resume` では base が上書きされない
- [ ] git repo 外の session では base 記録が起きない (エラーにもならない)
- [ ] hunk session がある時は `/session-diff` で reload が発火する
- [ ] hunk session が無い時は fallback コマンドが提示される

## Phase 2 判断のための観測ポイント

Phase 1 運用開始後 2-4 週で以下を体感する。
Phase 2 (PreToolUse への切替や併用) を判断する材料になる。

- base が古くなって困った回数を数える
- branch 切替や `git pull` で base の意味がずれるケースを記録する
- `~/.claude/tmp/session-base/` の累積ファイル数を確認する (相談だけ session の塵)
- `/session-diff` を実際に叩いた回数を数える
- そのうち役に立った回数を数える

上記が Phase 2 の spec 材料となる。
Phase 1 の段階では対策を先取りしない。
