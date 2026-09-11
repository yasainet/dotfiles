---
name: simplepowers-06-record
description: Simplepowers Record
allowed-tools: Bash(git *)
---

# Record

## Do

- 作業を commit や PR として残せ。通っていない Phase があっても実行してよい
  - commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある
  - commit の hash と変更規模を報告せよ

### Tools

| When            | Tools                             |
| --------------- | --------------------------------- |
| commit          | `/commit-commands:commit`         |
| push と PR まで | `/commit-commands:commit-push-pr` |
| release tag     | `/git-bump`                       |
| 積み残し        | `/git-issue`                      |

## Don't

- code の修正を禁止する。commit と PR だけを扱え
- 通らなかった Phase を黙るな。通らなかったと言え
- push していないのに黙るな。していないと言え

## Done

報告を終えたら止まれ。次の Phase はない。
