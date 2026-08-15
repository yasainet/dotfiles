---
name: simplepowers-05-review
description: [Review]
---

# Review

Start by declaring `[Review]`.

## Purpose

`Build` して `Verify` した該当部分に `Review` を行え。

## Scope

- 検証を終えてから適用する。終えていないなら `Verify` へ戻れ
- ドキュメントだけの変更に `/code-review` を掛けるな。読む code が無い

## Responsibilities

| When            | Tools                  |
| --------------- | ---------------------- |
| Only Documents  | rules review           |
| Developments    | `/code-review`         |
| Auth, API, etc. | `/security-review`     |
| Code Cleanup    | `/simplify`            |
| GitHub PR       | `/code-review PR #<N>` |

## Procedure

1. Responsibilities の該当する行を全て掛けよ
2. 指摘を潰せ。残すなら、残したと言え
3. 直した箇所を報告して止まれ。`user` の指示を待て
4. `Record` へ移行せよ
