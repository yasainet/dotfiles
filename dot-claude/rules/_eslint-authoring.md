---
paths:
  - "**/eslint/**/*.mjs"
---

# ESLint Rule Authoring

`@yasainet/eslint` のルールを新規追加 / 変更したら、対応する path-rule に反映せよ。
機械ルールは eslint が正典。rule .md はその転記 + eslint に無い Why を持つ。

手順:

- `npm run docs` を実行し `docs/rules.md`（機械可読カタログ）を再生成する
- 変更した rule の layer を特定する
  - 例: `layers/queries` → `~/.claude/rules/src/features/queries.md`
  - 例: `imports/top-level-lib` → `~/.claude/rules/src/lib.md`
- 該当 rule .md の機械ルール節へ転記する（せよ調・既存 voice に合わせる）
- そのルールの意図が非自明なら Why を `> [!NOTE]` でドラフトし、人間に確認する
- rule .md には「ESLint が最終保証、すり抜けるな」を冒頭で明示し続ける

> [!NOTE]
> 全自動 script にはできない。機械ルールの抽出 (`npm run docs`) は script だが、
> せよ調への翻訳と Why の起草は判断が要るため Claude Code が担い、Why は人間が承認する。
