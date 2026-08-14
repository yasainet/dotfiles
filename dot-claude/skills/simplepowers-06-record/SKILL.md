---
name: simplepowers-06-record
description: [Record] commit や PR を残すときに使え
allowed-tools: Bash(git *)
---

# Record

Start by declaring `[Record]`.

## Purpose

作業を commit や PR として残す。

## Scope

- 通っていない phase があっても適用してよい。報告で申告せよ
- commit と PR だけを扱え。code の修正はここでするな

## Responsibilities

| When            | Tools                             |
| --------------- | --------------------------------- |
| commit          | `/commit-commands:commit`         |
| push と PR まで | `/commit-commands:commit-push-pr` |
| release tag     | `/git-bump`                       |
| 積み残し        | `/git-issue`                      |

## Procedure

1. commit する前に `github.md` を読め。type、scope、body の規約がある
2. commit の hash と変更規模を報告せよ
3. 通らなかった phase があるなら、通らなかったと言え。push していないなら、していないと言え

## References

- `~/.claude/docs/github.md`: commit の type、scope、body の規約
