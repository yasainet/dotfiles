---
name: simplepowers-05-review
description: [Review] user がレビューを指示したときに使え。検証の後、記録の前に来る
---

# Review

Start by declaring `[Review]`.

## Scope

- Tools の該当する行を全て掛けよ
- ドキュメントだけの変更に `/code-review` を掛けるな。読む code が無い

## Tools

| When                   | Tools                  |
| ---------------------- | ---------------------- |
| ドキュメントだけ       | rules review           |
| code を触った          | `/code-review`         |
| 認証や外部入力を触った | `/security-review`     |
| bug ではなく整理が目的 | `/simplify`            |
| GitHub の PR           | `/code-review PR #<N>` |

## Goal

該当する review を全て掛け、指摘を全て潰せ。

直した箇所を報告せよ。残した指摘があるなら、残したと言え。

## Next phase

レビューを通したらここで止まれ。`user` の指示を待て。
