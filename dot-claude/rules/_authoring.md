---
paths:
  - "**/dot-claude/rules/**/*.md"
  - "**/.claude/rules/**/*.md"
---

# Rule Authoring

path-rule (`~/.claude/rules/**/*.md`) を編集するときの作法。

## 構造

- 2 層で書く: 機械ルール（eslint 転記）と Why（eslint に表せない意図）
- 機械ルールは eslint が正典。冒頭に「ESLint が最終保証、すり抜けるな」を置く
- Why は `> [!NOTE]` で書く。What / How はコードと eslint が持つので書かない
- voice はせよ調・1 文 1 義

## 配置

- `src/` 配下は project 構造ミラー（`src/lib.md`, `src/features/queries.md`）
- 横断的ルール（lint / md / supabase 等）は `rules/` 直下
- メタ rule は `_` 接頭辞（`_authoring.md`, `_eslint.md`）

## paths の glob

- `paths:` は rule ファイルの場所でなく project 側ファイルを狙う（discovery は再帰的）
- glob は標準だが、ルート直下狙い / 多段リテラルは確証がない
- 新規 rule や glob 変更は完全新規セッションで発火確認する（`--continue` は rule を再ロードしない）

## hook との結合

- green-field の Write-create は `hooks/inject-path-rule.mjs` が rule 本文を注入する
- rule ファイルを移動 / 追加したら、hook の `RULES` の `file` 参照を更新する
