---
name: simplepowers-review
description: [Review] phase: 検証の後、commit や PR の前に必ず使え
---

# Review

冒頭で `[Review]` と宣言せよ。

## Previous phase

検証を通したか確認せよ。通していないなら `simplepowers-verify` skill へ戻れ。

## Scope

該当する行を全て掛けよ。

| 対象                   | 掛けるもの             |
| ---------------------- | ---------------------- |
| ドキュメントだけ       | rules review           |
| code を触った          | `/code-review`         |
| 認証や外部入力を触った | `/security-review`     |
| bug ではなく整理が目的 | `/simplify`            |
| GitHub の PR           | `/code-review PR #<N>` |

### rules review

ドキュメントだけの変更に `/code-review` を掛けるな。読む code が無い。

変更した file の path に該当する `~/.claude/rules/**/*.md` を読め。該当は frontmatter の `paths` が決める。

規約の項目ごとに、変更した行が満たしているか確かめよ。

## Goal

該当する review を全て掛け、指摘を全て潰せ。

直した箇所を報告せよ。残した指摘があるなら、残したと言え。

## Next phase

レビューを通したら `simplepowers-record` skill へ進め。
