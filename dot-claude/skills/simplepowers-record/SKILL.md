---
name: simplepowers-record
description: [Record] phase: レビューを通した後、commit や PR を残すときに使え
---

# Record

冒頭で `[Record]` と宣言せよ。

## Previous phase

レビューを通したか確認せよ。通していないなら `simplepowers-review` skill へ戻れ。

## Scope

- commit の hash と変更規模を報告せよ
- push していないなら、していないと言え

### 使うもの

| やること        | 使うもの                          | 呼ぶ人 |
| --------------- | --------------------------------- | ------ |
| commit          | `/commit-commands:commit`         | 自分   |
| push と PR まで | `/commit-commands:commit-push-pr` | 自分   |
| release tag     | `/git-bump`                       | `user` |
| 積み残し        | `/git-issue`                      | `user` |

`user` の欄は自分では呼べない。実行を依頼せよ。

### 書き方

commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある。
