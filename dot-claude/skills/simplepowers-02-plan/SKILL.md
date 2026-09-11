---
name: simplepowers-02-plan
description: Simplepowers Plan
---

# Plan

## Do

- `Explore` で合意した Goal を `Plan` として提示せよ
  - 変更対象が軽微である: markdown, diff で該当部分を提示せよ
  - 変更対象が軽微ではない: `@Plan` で `./.claude/plans/*.md` に書け

### Tools

| When                               | Tools   |
| ---------------------------------- | ------- |
| `user` が `@Plan` の指示をした場合 | `@Plan` |

## Don't

- `./.claude/plans/*.md` 以外のファイルの編集を禁止する

## Done

`user` が `Plan` を承認したら `Build` へ移行せよ。
