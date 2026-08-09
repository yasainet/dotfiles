---
name: simplepowers-record
description: [Record] phase: レビューを通した後、commit や PR を残すときに使え
---

# Record

冒頭で `[Record]` と宣言せよ。

## Previous phase

レビューを通したか確認せよ。通していないなら `simplepowers-review` skill へ戻れ。

## Scope

### 使うもの

| やること        | 使うもの                          |
| --------------- | --------------------------------- |
| commit          | `/commit-commands:commit`         |
| push と PR まで | `/commit-commands:commit-push-pr` |
| release tag     | `/git-bump`                       |
| 積み残し        | `/git-issue`                      |

### 書き方

commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある。

## Goal

commit を残せ。hash と変更規模を報告せよ。

push していないなら、していないと言え。
