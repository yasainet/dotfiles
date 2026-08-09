---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback
---

# Using Git Worktrees

## Overview

作業を隔離した workspace の中で行え。platform 本来の worktree tool を優先せよ。それが無いときだけ、手動の git worktree に落とせ。

核となる原則: まず既に隔離されているか判定せよ。次に本来の tool を使え。次に git に落とせ。harness と争うな。

開始時に宣言せよ: 「using-git-worktrees skill を使って隔離した workspace を用意します。」

## Step 0: Detect Existing Isolation

何かを作る前に、既に隔離した workspace の中にいないか確認せよ。

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

submodule への注意: `GIT_DIR != GIT_COMMON` は git submodule の中でも成り立つ。「既に worktree の中だ」と結論する前に、submodule でないことを確かめよ。

```bash
# If this returns a path, you're in a submodule, not a worktree — treat as normal repo
git rev-parse --show-superproject-working-tree 2>/dev/null
```

`GIT_DIR != GIT_COMMON` かつ submodule でないなら: 既に linked worktree の中にいる。Step 2 (Project Setup) へ飛べ。別の worktree を作るな。

branch の状態と共に報告せよ。
- branch 上にいる: 「既に `<path>` の隔離した workspace にいます。branch は `<name>` です。」
- detached HEAD: 「既に `<path>` の隔離した workspace にいます (detached HEAD、外部管理)。仕上げの時点で branch の作成が要ります。」

`GIT_DIR == GIT_COMMON` なら (または submodule の中なら): 通常の repo の checkout の中にいる。

worktree についての `user` の好みが、既に指示にあるか。無いなら、worktree を作る前に同意を求めよ。

> 「隔離した worktree を用意しましょうか。今の branch を変更から守れます。」

既に表明された好みがあるなら、尋ねずにそれに従え。`user` が断ったなら、その場で作業し Step 2 へ飛べ。

## Step 1: Create Isolated Workspace

手段は二つある。この順に試せ。

### 1a. Native Worktree Tools (preferred)

`user` は隔離した workspace を望んだ (Step 0 の同意)。worktree を作る手段を既に持っているか。`EnterWorktree` や `WorktreeCreate` のような名前の tool、`/worktree` command、`--worktree` flag かもしれない。あるなら、それを使い Step 2 へ飛べ。

本来の tool は、置き場所、branch の作成、後片付けを自動で扱う。本来の tool があるのに `git worktree add` を使うと、harness からは見えず管理もできない幽霊の状態を作る。

本来の worktree tool が無いときだけ、Step 1b へ進め。

### 1b. Git Worktree Fallback

Step 1a が当てはまらないときだけ使え。本来の worktree tool が無い場合だ。git で手動 worktree を作れ。

#### Directory Selection

この優先順に従え。`user` の明示的な好みは、観測した file 構成に常に勝る。

1. 指示の中に worktree directory の好みが表明されていないか確認せよ。`user` が既に指定しているなら、尋ねずにそれを使え

2. project 内に既存の worktree directory が無いか確認せよ:
   ```bash
   ls -d .worktrees 2>/dev/null     # Preferred (hidden)
   ls -d worktrees 2>/dev/null      # Alternative
   ```
   あればそれを使え。両方あるなら `.worktrees` が勝つ

3. 他に手掛かりが無ければ、project の root の `.worktrees/` を既定とせよ

#### Safety Verification (project-local directories only)

worktree を作る前に、その directory が ignore されていることを必ず確かめよ。

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

ignore されていないなら: .gitignore に足し、その変更を commit してから進め。

なぜ重要か: worktree の中身を誤って repository に commit するのを防ぐ。

#### Create the Worktree

```bash
# Determine path based on chosen location
path="$LOCATION/$BRANCH_NAME"

git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

sandbox での代替: `git worktree add` が権限の error で失敗したら (sandbox による拒否)、`user` にこう伝えよ。sandbox が worktree の作成を塞いだので、今の directory で作業する。その上で、その場で準備と基準の test を実行せよ。

## Step 2: Project Setup

自動で判定し、適切な準備を実行せよ。

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

## Step 3: Verify Clean Baseline

workspace が綺麗な状態から始まることを確かめるため、test を実行せよ。

```bash
# Use project-appropriate command
npm test / cargo test / pytest / go test ./...
```

test が落ちたら: 失敗を報告し、進めるか調べるかを尋ねよ。

test が通ったら: 準備完了を報告せよ。

### Report

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| 状況 | 行動 |
|-----------|--------|
| 既に linked worktree の中 | 作成を飛ばす (Step 0) |
| submodule の中 | 通常の repo として扱う (Step 0 の注意) |
| 本来の worktree tool がある | それを使う (Step 1a) |
| 本来の tool が無い | git worktree に落とす (Step 1b) |
| `.worktrees/` がある | それを使う (ignore を確認) |
| `worktrees/` がある | それを使う (ignore を確認) |
| 両方ある | `.worktrees/` を使う |
| どちらも無い | 指示 file を確認し、既定の `.worktrees/` |
| directory が ignore されていない | .gitignore に足して commit |
| 作成時に権限の error | sandbox での代替。その場で作業 |
| 基準の test が落ちる | 失敗を報告して尋ねる |
| package.json/Cargo.toml が無い | 依存の導入を飛ばす |

## Common Rationalizations

| 言い訳 | 実際 |
|--------|---------|
| 「明らかに worktree の中ではない。確認は要らない」 | Step 0 を実行せよ。harness が作った隔離も submodule も、見ただけでは分からない。判定の command が答えを出す。 |
| 「本来の tool を探すより `git worktree add` が速い」 | 本来の tool (例: `EnterWorktree`) が置き場所、branch、後片付けを担う。それを迂回するのが最大の誤りだ。harness から見えず管理もできない幽霊の状態を作る。 |
| 「worktree の directory はきっと ignore 済みだ」 | `git check-ignore` を実行せよ。ignore されていない worktree directory は、木全体を repo に commit する。 |
| 「directory 名は何でもよい」 | 明示的な指示が、project 内の既存 directory に勝ち、それが既定の `.worktrees/` に勝つ。 |
| 「workspace は新しい。基準の test は後でよい」 | 基準が汚れていると、後の失敗が全て曖昧になる。今 test を実行せよ。失敗を押し切るかは人間の相棒の判断だ。 |
