---
name: simplepowers-04-review
description: Simplepowers Review
---

# Review

## Do

- skill は Agent tool で `model: sonnet` の subagent を起動し、その中で Skill tool から実行せよ

## Don't

- ドキュメントだけの場合、review 不要

## Done

- `Review` を終えたら `Record` へ移行せよ

## Tools

| When            | Tools                  |
| --------------- | ---------------------- |
| Developments    | `/code-review <path>`  |
| Auth, API, etc. | `/security-review`     |
| Code Cleanup    | `/simplify`            |
| PR              | `/code-review PR #<N>` |
