---
name: simplepowers-05-record
description: Simplepowers Record
allowed-tools: Bash(git *)
---

# Record

## Do

- 作業を commit や PR として残せ。通っていない Phase があっても実行してよい
  - commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある
  - commit の hash と変更規模を報告せよ

## Don't

## Done

## Tools

| When        | Tools                             |
| ----------- | --------------------------------- |
| commit      | `/commit-commands:commit`         |
| push, PR    | `/commit-commands:commit-push-pr` |
| release tag | `/git-bump`                       |
| 積み残し    | `/git-issue`                      |
