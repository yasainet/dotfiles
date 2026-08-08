---
name: simplepowers-review
description: レビュー phase。検証の後、commit や PR の前に必ず使え
---

# レビュー

冒頭で `[レビュー]` と宣言せよ。

## 選び方

| 対象 | 使うもの |
| --- | --- |
| 既定 | `/code-review` |
| 認証や外部入力を触った | `/code-review` に `/security-review` を足せ |
| bug ではなく整理が目的 | `/simplify` |
| GitHub の PR | `/review` |

## 出口

レビューを通してから記録に進め。

| やること | 使うもの |
| --- | --- |
| commit | `/commit-commands:commit` |
| push と PR まで | `/commit-commands:commit-push-pr` |
| release tag | `/git-bump` |
| 積み残し | `/git-issue` で issue にせよ |

commit の書き方は `~/.claude/docs/github.md` に従え。
