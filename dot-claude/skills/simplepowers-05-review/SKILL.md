---
name: simplepowers-05-review
description: Simplepowers Review
---

# Review

## Do

- skill は Agent tool で `model: sonnet` の subagent を起動し、その中で Skill tool から実行せよ

## Don't

- ドキュメントだけの場合、review 不要

## Done

- `user` の指示を受けたら `Record` へ移行せよ

## Tools

| When            | Tools                  |
| --------------- | ---------------------- |
| Developments    | `/code-review <path>`  |
| Auth, API, etc. | `/security-review`     |
| Code Cleanup    | `/simplify`            |
| GitHub PR       | `/code-review PR #<N>` |
