---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

計画を読み込み、批判的に検討せよ。全ての task を実行し、終わったら報告せよ。

開始時に宣言せよ: 「executing-plans skill を使ってこの計画を実装します。」

注意: Superpowers は subagent を使える環境の方がはるかにうまく働く。そう人間の相棒に伝えよ。Claude Code、Codex CLI、Codex App、Copilot CLI、Gemini CLI はいずれも該当する。platform ごとの tool 対応表は `../using-superpowers/references/` にある。subagent が使えるなら、この skill ではなく superpowers:subagent-driven-development を使え。

## The Process

### Step 1: Load and Review Plan
1. 隔離した作業場を用意せよ。superpowers:using-git-worktrees で作るか、既存のものを確かめる
2. 計画 file を読め
3. 批判的に検討せよ。計画への疑問や懸念を洗い出す
4. 懸念があるなら、始める前に人間の相棒に伝えよ
5. 懸念が無いなら、計画の項目から todo を作り、進めよ

### Step 2: Execute Tasks

task ごとに:
1. in_progress にする
2. 各 step を正確に辿る (計画は一口大の step になっている)
3. 指定された検証を実行する
4. completed にする

### Step 3: Complete Development

全ての task を終え検証したら:
- 宣言せよ: 「finishing-a-development-branch skill を使ってこの作業を仕上げます。」
- 必須の sub-skill: superpowers:finishing-a-development-branch を使え
- その skill に従い、test を確かめ、選択肢を示し、選ばれた方を実行せよ

## When to Stop and Ask for Help

次のときは、直ちに実行を止めよ。
- 行き止まりに当たった (依存が無い、test が落ちる、指示が不明瞭)
- 計画に致命的な穴があり、着手できない
- 指示が理解できない
- 検証が何度も失敗する

推測するな。確認を求めよ。

## When to Revisit Earlier Steps

次のときは検討 (Step 1) に戻れ。
- 相棒があなたの feedback を受けて計画を更新した
- 根本の方針を考え直す必要がある

行き止まりを力ずくで通るな。止まって尋ねよ。

## Remember
- まず計画を批判的に検討せよ
- 計画の step を正確に辿れ
- 検証を飛ばすな
- 計画が指す skill を参照せよ
- 詰まったら止まれ。推測するな
- `user` の明示的な同意なしに、main/master branch で実装を始めるな
