---
name: simplepowers-review
description: レビュー phase。検証の後、commit や PR の前に必ず使え
---

# レビュー

冒頭で `[Review]` と宣言せよ。

## 選び方

`/code-review` は必ず掛けよ。他は対象に応じて足せ。

| 対象                   | 足すもの              |
| ---------------------- | --------------------- |
| 認証や外部入力を触った | `/security-review`    |
| bug ではなく整理が目的 | `/simplify`           |
| GitHub の PR           | `/code-review <番号>` |

## 出口

レビューを通してから記録に進め。

| やること        | 使うもの                          | 呼ぶ人 |
| --------------- | --------------------------------- | ------ |
| commit          | `/commit-commands:commit`         | 自分   |
| push と PR まで | `/commit-commands:commit-push-pr` | 自分   |
| release tag     | `/git-bump`                       | `user` |
| 積み残し        | `/git-issue`                      | `user` |

`user` の欄は自分では呼べない。実行を依頼せよ。

commit の書き方は `~/.claude/docs/github.md` に従え。
