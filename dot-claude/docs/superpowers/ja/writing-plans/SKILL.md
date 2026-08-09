---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

実装計画は、この codebase の文脈を全く知らず、趣味も怪しい技術者に向けて書け。必要なことを全て書け。task ごとに触る file、code、test、見るべき文書、test の仕方。計画全体を一口大の task にして渡せ。DRY。YAGNI。TDD。こまめな commit。

相手は熟練した開発者だが、我々の道具立てと問題領域はほとんど知らないと想定せよ。良い test の設計にもあまり詳しくないと想定せよ。

開始時に宣言せよ: 「writing-plans skill を使って実装計画を作ります。」

前提: 隔離した worktree で作業するなら、実行の時点で `superpowers:using-git-worktrees` skill によって作られているはずだ。

計画の保存先: `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (計画の置き場所について `user` の好みがあれば、この既定より優先する)

## Scope Check

仕様が独立した subsystem を複数含むなら、brainstorming の段階で sub-project ごとの仕様に分けられているはずだ。分かれていないなら、subsystem ごとに別々の計画へ分けることを提案せよ。各計画は、それ単体で動作し test できる software を生むこと。

## File Structure

task を定める前に、どの file を作りどの file を変えるか、それぞれが何を担うかを描け。分割の判断はここで固まる。

- 境界が明確で interface のはっきりした単位を設計せよ。file ごとに責務は一つ
- 一度に context へ収まる code の方がうまく推論でき、file の焦点が絞られているほど編集は確実になる。多くを抱えた大きな file より、小さく焦点の絞られた file を選べ
- 一緒に変わる file は一緒に置け。技術的な層ではなく責務で分けよ
- 既存の codebase では、定着した書き方に従え。大きな file を使う codebase なら、独断で作り直すな。ただし自分が触る file が扱いにくいほど育っているなら、分割を計画に含めてよい

この構造が task の分割を決める。task ごとに、それ単体で意味の通る自己完結した変更を生むこと。

## Task Right-Sizing

task とは、自前の test 周期を持ち、新しい reviewer の関門に掛ける価値のある最小の単位だ。task の境界を引くときは、準備、設定、足場作り、文書化の step を、それを必要とする成果物の task に畳み込め。分けるのは、reviewer が一方を拒み隣を承認できる場合だけだ。task はそれぞれ、独立して test できる成果物で終わること。

## Bite-Sized Task Granularity

step は一つの行動 (2〜5 分):
- 「失敗する test を書く」— step
- 「実行して失敗することを確かめる」— step
- 「test を通す最小限の code を書く」— step
- 「test を実行して通ることを確かめる」— step
- 「commit する」— step

## Plan Document Header

全ての計画は、この header で始めること。

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

step には、技術者が必要とする実際の中身を必ず書け。次は計画の失敗だ。決して書くな。
- 「TBD」「TODO」「後で実装」「詳細を埋める」
- 「適切な error 処理を足す」「検証を足す」「境界の場合を扱う」
- 「上記の test を書く」(実際の test code が無いもの)
- 「Task N と同様」(code を繰り返せ。技術者は task を順番通りに読むとは限らない)
- 何をするかだけ述べ、どうするかを示さない step (code の step には code block が要る)
- どの task でも定義されていない型、関数、method への参照

## Self-Review

計画を書き終えたら、新しい目で仕様を見て、計画と突き合わせよ。これは自分で回す checklist であり、subagent の起動ではない。

1. 仕様の網羅: 仕様の各節と各要件をざっと見よ。それを実装する task を指せるか。抜けを挙げよ。

2. 穴の走査: 上の「No Placeholders」の型に当たるものが計画に無いか探せ。直せ。

3. 型の整合: 後の task で使った型、method の署名、property 名は、前の task で定義したものと一致するか。Task 3 で `clearLayers()`、Task 7 で `clearFullLayers()` なら、それは bug だ。

問題を見つけたら、その場で直せ。再 review は要らない。直して先へ進め。task の無い仕様の要件を見つけたら、task を足せ。

## Execution Handoff

計画を保存したら、実行方法の選択肢を示せ。

「計画が完成し、`docs/superpowers/plans/<filename>.md` に保存しました。実行方法は二つあります。

1. Subagent-Driven (推奨) — task ごとに新しい subagent を起動し、task の合間に review します。速く回ります

2. Inline Execution — executing-plans を使い、この session で task を実行します。要所で確認しながらまとめて進めます

どちらにしますか。」

Subagent-Driven を選んだ場合:
- 必須の sub-skill: superpowers:subagent-driven-development を使え
- task ごとに新しい subagent + 二段階の review

Inline Execution を選んだ場合:
- 必須の sub-skill: superpowers:executing-plans を使え
- 要所で review を挟みつつ、まとめて実行
