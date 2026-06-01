---
name: jsdoc
description: [Skills] Refine JSDoc on queries/services to Why-not
argument-hint: [path | feature]
disable-model-invocation: true
allowed-tools: Read, Edit, Grep, Glob, Bash(git *), Bash(npx eslint *)
---

# Jsdoc skill

ESLint は queries / services の public 関数に JSDoc の存在を強制する（決定論）。
だが内容が Why-not か What かは機械判断できない。
本 skill はその残余を精査する。

## Principle

- JSDoc = Why-not のみ。コードから復元できない非自明性を書く
  - How はコードの担当、What はテストの担当、Why はコミットログの担当
- What の言い換えは削除対象（関数名 + 引数 + 型から復元できる記述）
- Why-not は context に無いと書けない。判定前に対象の外部挙動を調査せよ

### 層ごとの Why-not の在り処

- queries: Supabase RLS の可視性 / index の罠（1-indexed vs 0-indexed）/ count セマンティクス / consume する route
- services: upsert キー / skip 条件 / 整合性方針（all-or-nothing 等）/ 副作用の順序 / best-effort をやめた理由

### Form

- 事実 1 つ → single-line `/** <why-not> */`
- 独立した条件・挙動が 2 つ以上 → multi-line（Summary + Lists）
- tags 禁止（TS が型の真実源。`@param` 等は二重写し）
- 一文一義 / 1 行 60 字以内を推奨

## Scope

- default = 変更ファイル（`git diff`）。日常 PR / 新規 PJ の反復ケース
- `/jsdoc <path|feature>` = 指定範囲
- `/jsdoc all` = 既存 PJ の full-audit。feature 単位で分割実行せよ
  - 一括 slurp は per-function の Why-not context を薄め精度が落ちる（粒度 = 精度の上限）
- 既存 JSDoc の一括削除 → 再生成は禁止。Why-not は復元不能に失われる

## Steps

1. `## Scope` に従い対象を確定する

```bash
git diff --name-only HEAD
git diff --name-only --cached
```

   - queries / services の `*.ts` のみ対象。entries / utils / schemas は対象外

2. 各 public 関数の JSDoc を抽出し、現状を把握する

3. Why-not を調査する（判定の前提）
   - query: 触る table の RLS policy、index、呼び出し元の route
   - service: upsert キー、副作用、整合性方針

4. 判定して書き換える
   - What の言い換え → Why-not へ書き換える
   - 既に Why-not → keep する
   - form 不一致（2 条件以上なのに single-line 等）→ 修正する
   - tags あり → 除去する
   - 非自明性ゼロ → 最小 single-line を残す（presence は linter が要求。削除しない）

5. lint で presence を確認する

```bash
npx eslint <files>
```
