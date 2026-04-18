---
name: push
description: 現在のブランチを push する。--tag を付けると、最新タグをインクリメントして push する
argument-hint: [--tag]
allowed-tools: Bash(git *)
---

# Push

- 引数: $ARGUMENTS
- 最新タグ: `!git describe --tags --abbrev=0`

1. `git push`

`$ARGUMENTS` に `--tag` が含まれる場合は、追加で:

2. 最新タグの **patch** バージョンをインクリメントする（例: `v0.0.0` → `v0.0.1`）
3. `git tag vX.X.X`
4. `git push origin vX.X.X`
