---
name: simplepowers-05-review
description: Simplepowers Review
---

# Review

## Do

- `Build` して `Verify` した該当部分に、Tools の該当する行を全て掛けよ
  - skill は Agent tool で `model: sonnet` の subagent を起動し、その中で Skill tool から実行せよ。skill が fork する review agent も sonnet を継承する
  - `<path>` は `Build` で変更した file を渡せ。`git status` で確認できる。省略すると未 push の commit も全て対象になる

## Don't

- ドキュメントだけの場合、review 不要

## Done

`user` の指示を受けたら `Record` へ移行せよ。

## Tools

| When            | Tools                  |
| --------------- | ---------------------- |
| Developments    | `/code-review <path>`  |
| Auth, API, etc. | `/security-review`     |
| Code Cleanup    | `/simplify`            |
| GitHub PR       | `/code-review PR #<N>` |
