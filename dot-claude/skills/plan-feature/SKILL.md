---
name: plan-feature
description: Plan a new feature before writing code. Skip for bug fixes or refactors.
allowed-tools: Read, Glob, Grep, Bash(fd *), Bash(rg *), EnterPlanMode
---

# Plan Feature

新機能の実装計画は、以下 4 層に**必ず分割**して立てる。1 層ずつ実装・検証してから次に進む。
混ぜると後でやり直しが発生する。

## レイヤー

1. **schema** — `supabase/**/*.schema.sql`
   - テーブル、RLS、関数、型生成 (`supabase gen types`)
   - 完了条件: マイグレーション適用 + 型ファイル更新
2. **features** — `**/features/**/*.ts`, `**/route.ts`
   - サーバ処理、API ルート、ドメインロジック、Server Actions
   - 完了条件: 単体で叩いて期待値が返る
3. **components** — `**/components/**/*.tsx`, `**/page.tsx`
   - UI、ルーティング、features の呼び出し
   - 完了条件: ブラウザで golden path 動作確認
4. **tests** — `**/tests/**/*.ts`
   - E2E / 結合テスト
   - 完了条件: CI 緑

## 手順

1. ユーザー要求を 1 行に要約する
2. 関連ファイルを調査する (既存 schema / features / components / tests)
3. 上記 4 層それぞれについて以下を列挙し、`EnterPlanMode` で提示する:
   - **対象ファイル** (新規 or 編集)
   - **変更内容の要点** (1〜3 行)
   - **完了条件**
4. ユーザー承認後、**1 層目から順に**実装する。複数層を同時に書き始めない

## 禁止事項

- 4 層を 1 つの大きな TODO に束ねること
- schema を後回しにして features から書き始めること
- 計画に「テスト」項目が無いこと
