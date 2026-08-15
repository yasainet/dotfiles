---
name: simplepowers-02-plan
description: [Plan]
---

# Plan

Start by declaring `[Plan]`.

## Purpose

`Explore` で合意した Goal を `Plan` として提示して、`user` が承認する。

## Scope

- `Explore` で合意した Goal を `Plan` として提示せよ
  - 変更対象が軽微である: markdown diff を利用して該当部分を提示せよ
  - 変更対象が軽微ではない: `@Plan` を利用せよ
- `Plan` では、あらゆるファイルに対する編集を禁止する
  - `@Plan` では、`./.claude/plans/*.md` に書き込みせよ

## Responsibilities

| When                               | Tools   |
| ---------------------------------- | ------- |
| `user` が `@Plan` の指示をした場合 | `@Plan` |

## Procedure

1. `Explore` で合意した Goal を `Plan` として提示せよ
2. `user` が承認をした場合にのみ、`Build` へ移行せよ

## References

N/A
