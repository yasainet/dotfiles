---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

問題が波及する前に捕まえるため、code reviewer の subagent を起動せよ。reviewer には、評価のために正確に組み立てた文脈だけを渡す。あなたの session の履歴は決して渡すな。

核となる原則: 早く review せよ。何度も review せよ。

## When to Request Review

必須:
- subagent-driven development の task ごと
- 大きな機能を完成させた後
- main への merge の前

任意だが有益:
- 詰まったとき (新しい視点)
- refactoring の前 (基準の確認)
- 込み入った bug を直した後

## How to Request

1. git の SHA を得る:
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

2. code reviewer の subagent を起動する:

`general-purpose` の subagent を起動し、[code-reviewer.md](code-reviewer.md) の template を埋めよ。

穴:
- `{DESCRIPTION}` — 作ったものの短い要約
- `{PLAN_OR_REQUIREMENTS}` — 何をするべきか
- `{BASE_SHA}` — 開始の commit
- `{HEAD_SHA}` — 終了の commit

3. feedback に応じて動く:
- Critical は直ちに直す
- Important は先へ進む前に直す
- Minor は後のために控えておく
- reviewer が誤っているなら、理由を添えて押し返す

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code reviewer subagent]
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from docs/superpowers/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

## Common Rationalizations

| 言い訳 | 実際 |
|--------|---------|
| 「reviewer を起動せず、自分で diff を見ればよい」 | あなたは調整役だ。その場で diff を読むと、作業を進めるために要る context window を焼く。reviewer subagent を起動せよ。diff と評価はその context に置かれ、あなたには findings だけが返る。 |
| 「変更を理解するには、reviewer に session の履歴が全部要る」 | 正確に組み立てた文脈を渡せ。session の履歴は決して渡すな。そうすれば reviewer は、あなたの思考過程ではなく成果物に集中できる。 |

## Red Flags

決してするな:
- 「単純だから」と review を飛ばす
- Critical を無視する
- Important を直さずに進む
- 妥当な技術的 feedback に言い争う

reviewer が誤っているなら:
- 技術的な理由を添えて押し返す
- 動くことを示す code や test を見せる
- 説明を求める

template はここ: [code-reviewer.md](code-reviewer.md)
