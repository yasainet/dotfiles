---
name: simplepowers-06-record
description: [Record] commit や PR を残すときに使え
allowed-tools: Bash(git *)
---

# Record

Start by declaring `[Record]`.

## Scope

- commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある

## Tools

| When            | Tools                             |
| --------------- | --------------------------------- |
| commit          | `/commit-commands:commit`         |
| push と PR まで | `/commit-commands:commit-push-pr` |
| release tag     | `/git-bump`                       |
| 積み残し        | `/git-issue`                      |

## Goal

commit を残せ。hash と変更規模を報告せよ。

通らなかった phase があるなら、通らなかったと言え。

push していないなら、していないと言え。
