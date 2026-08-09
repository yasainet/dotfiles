## Subagent dispatch requires multi-agent support

Codex の config (`~/.codex/config.toml`) に次を足せ。

```toml
[features]
multi_agent = true
```

これで `spawn_agent`, `wait_agent`, `close_agent` が有効になり、`dispatching-parallel-agents` や `subagent-driven-development` のような skill が使える。subagent-driven-development を使うときは、review が返ってきた reviewer subagent を閉じよ。implementer subagent は、その task の review が通るまで開いたままにせよ。fix loop が implementer を再開するからだ。通ったら閉じよ。起動済みの agent へ追加の message を送れない harness なら、fix の回ごとに新しい implementer を起動せよ。brief と report file と findings を渡す。

## Environment Detection

worktree を作る skill や branch を仕上げる skill は、進む前に read-only の git command で環境を判定せよ。

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR != GIT_COMMON` → 既に linked worktree の中にいる (作成を飛ばす)
- `BRANCH` が空 → detached HEAD (sandbox から branch/push/PR はできない)

各 skill がこの signal をどう使うかは、`using-git-worktrees` の Step 0 と `finishing-a-development-branch` の Step 1 を見よ。

## Codex App Finishing

sandbox が branch/push 操作を塞いでいるとき (外部管理の worktree で detached HEAD のとき)、agent は作業を全て commit する。その上で、App 本来の操作を使うよう `user` に伝える。

- 「Create branch」— branch に名前を付け、App の UI から commit/push/PR する
- 「Hand off to local」— `user` の local checkout へ作業を渡す

agent は test の実行、file の stage、branch 名や commit message や PR 説明文の候補の出力までは行える。`user` はそれを copy すればよい。
