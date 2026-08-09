---
name: simplepowers-06-record
description: [Record] phase: commit や PR を残すときに使え
---

# Record

冒頭で `[Record]` と宣言せよ。

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

飛ばした optional phase があるなら、飛ばしたと言え。

push していないなら、していないと言え。
