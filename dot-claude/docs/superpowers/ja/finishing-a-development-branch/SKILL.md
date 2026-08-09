---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work
---

# Finishing a Development Branch

## Overview

核となる原則: test を確かめる → 環境を判定する → 選択肢を示す → 選ばれた方を実行する → 片付ける。

開始時に宣言せよ: 「finishing-a-development-branch skill を使ってこの作業を仕上げます。」

## Step 1: Verify Tests

project の test 一式を丸ごと実行せよ (`npm test` / `cargo test` / `pytest` / `go test ./...`)。

test が落ちたら、失敗を報告して止まれ。選択肢を示すのは test 一式が緑になった後だ。

```
Tests failing (<N> failures). Must fix before completing:

[Show failures]
```

test が通ったら: Step 2 へ進め。

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# Capture now, while still inside the workspace — Step 5 changes directory
# before cleanup (Step 6) needs this value
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

これで、どの選択肢を示すか、後片付けをどうするかが決まる。

| 状態 | 選択肢 | 後片付け |
|-------|------|---------|
| `GIT_DIR == GIT_COMMON` (通常の repo) | 標準の 3 択 | 片付ける worktree は無い |
| `GIT_DIR != GIT_COMMON`、branch 名あり | 標準の 3 択 | 出自に応じて (Step 6 を見よ) |
| `GIT_DIR != GIT_COMMON`、detached HEAD | 2 択に絞る (merge 無し) | 外部管理。そのまま残す |

## Step 3: Determine Base Branch

base branch とは、この作業が分かれた元だ。多くは計画、会話、branch の upstream に名前がある。まだ分からないなら尋ねよ: 「この branch は <推測> から分かれたようですが、合っていますか。」merge の前に確認せよ。誤った base への merge は取り消しが高くつく。

## Step 4: Present Options

通常の repo と branch 名のある worktree — 次の 3 択をそのまま示せ。

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)

Which option?
```

detached HEAD — 次の 2 択をそのまま示せ。

```
Implementation complete. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)

Which option?
```

書かれた通りに示せ。簡潔に、上の一覧にある選択肢だけを出せ。作業を捨てるのは、人間の相棒が明示的にそう求めたときだけだ (下の「人間の相棒が作業を捨てるよう求めたら」を見よ)。相棒の答えを待て。統合の判断は相棒のものだ。

## Step 5: Execute Choice

### Option 1: Merge Locally

```bash
# Get main repo root for CWD safety
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

# Merge first — verify success before removing anything
git checkout <base-branch>
git pull
git merge <feature-branch>

# Verify tests on merged result
<test command>
```

merge した結果で test が落ちたら: 止まれ。worktree と branch はそのまま残し、調べよ。まだ push していないので、merge は local に留まり戻せる。

merge した結果が緑になったら: worktree を片付け (Step 6)、次に branch を消せ。

```bash
git branch -d <feature-branch>
```

### Option 2: Push and Create PR

```bash
git push -u origin <feature-branch>
# From a detached HEAD, name the new branch on the remote:
# git push origin HEAD:refs/heads/<new-branch>
```

その上で、<base-branch> に対する pull/merge request を forge の道具で作れ。CLI があればそれを使い、無ければ push 時に多くの forge が出す作成用の URL を使え。repo に PR の template や慣習があれば従い、URL を人間の相棒に伝えよ。

worktree は残せ。相棒は PR の feedback をそこで直す。

### Option 3: Keep As-Is

報告せよ: 「branch <name> を残します。worktree は <path> に保ちます。」

### 人間の相棒が作業を捨てるよう求めたら

この道は、捨てるよう明示的に求められたときだけ存在する。まず確認せよ。

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

その通りの確認を待て。届いたら:

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

その後 worktree を片付け (Step 6)、branch を強制的に消せ。

```bash
git branch -D <feature-branch>
```

## Step 6: Cleanup Workspace

Option 1 と、確認済みの破棄のときに実行する。Option 2 と 3 は常に worktree を残す。どちらの呼び出し元も、既に main repo の root へ移動している (worktree の削除は worktree の外から実行する必要がある)。Step 2 で控えた `GIT_DIR`/`GIT_COMMON`/`WORKTREE_PATH` の値を使え。directory を移る前に取ったものだ。

`GIT_DIR == GIT_COMMON` なら: 通常の repo だ。片付ける worktree は無い。終わり。

`WORKTREE_PATH` が `.worktrees/` か `worktrees/` の下なら: この worktree は Superpowers が作った。片付けは我々の担当だ。

```bash
git worktree remove "$WORKTREE_PATH"
git worktree prune  # Self-healing: clean up any stale registrations
```

そうでないなら: この workspace は host 環境のものだ。そのまま残せ。platform が workspace を抜ける tool を持つなら、それを使え。

## Quick Reference

| 選択肢 | merge | push | worktree を残す | branch の片付け |
|--------|-------|------|---------------|----------------|
| 1. local で merge | する | - | - | する |
| 2. PR を作る | - | する | 残す | - |
| 3. そのまま残す | - | - | 残す | - |
| 破棄 (明示的な依頼のみ) | - | - | - | する (強制) |

## Common Rationalizations

| 言い訳 | 実際 |
|--------|---------|
| 「この session の前の方で test は通った」 | 統合しようとしている木の上で test 一式を実行せよ。緑の実行は、実行した木についてしか証明しない。 |
| 「merge したいに決まっている」 | 統合は人間の相棒の判断だ。選択肢を示して待て。 |
| 「この機能はもう終わりのようだ。破棄を提案しよう」 | 選択肢は書かれた通りで完結している。破棄は相棒が言葉でそう求めたときだけだ。 |
| 「『うん、消して』は確認に当たる」 | 削除を許すのは、打ち込まれた `discard` の一語だけだ。 |
| 「PR を出したので worktree は邪魔だ」 | PR の feedback はその worktree で直す。作業が着地するまで残す。 |
| 「この別の worktree は古そうだ。ついでに片付けよう」 | 片付けてよいのは `.worktrees/` か `worktrees/` の下の worktree だけだ。他は全て host のものだ。 |
| 「merge 結果の失敗はたぶん不安定な test だ」 | merge 結果の失敗は全てを止める。調べる間、branch と worktree はそのままだ。 |
| 「base branch は当然 main だ」 | 分岐点を確認するか尋ねよ。誤った base への merge は取り消しが高くつく。 |
| 「push が拒まれた。force-push で直る」 | 拒否は remote が進んだ印だ。調べよ。force-push は人間の相棒の明示的な依頼があるときだけだ。 |
