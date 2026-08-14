---
name: simplepowers-05-review
description: [Review] user がレビューを指示したときに使え。検証の後、記録の前に来る
---

# Review

Start by declaring `[Review]`.

## Purpose

該当する review を全て掛け、指摘を潰し切る。

## Scope

- 検証を終えてから適用する。終えていないなら `Verify` へ戻れ
- ドキュメントだけの変更に `/code-review` を掛けるな。読む code が無い

## Responsibilities

| When                   | Tools                  |
| ---------------------- | ---------------------- |
| ドキュメントだけ       | rules review           |
| code を触った          | `/code-review`         |
| 認証や外部入力を触った | `/security-review`     |
| bug ではなく整理が目的 | `/simplify`            |
| GitHub の PR           | `/code-review PR #<N>` |

## Procedure

1. Responsibilities の該当する行を全て掛けよ
2. 指摘を潰せ。残すなら、残したと言え
3. 直した箇所を報告して止まれ。`user` の指示を待て
