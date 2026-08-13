---
name: simplepowers-02-plan
description: [Plan] 実装方針を決めるときに使え。調査の後、実装の前に来る
---

# Plan

Start by declaring `[Plan]`.

## Previous phase

調査を終えたか確認せよ。足りないなら `simplepowers-01-explore` skill へ戻れ。

## Scope

- 案を並べるな。推奨を 1 つ出せ
- 却下した案があるなら、理由を 1 行で添えよ
- one-way door を含むなら `user` と協議せよ。two-way door に変える設計を提示せよ

## Tools

| When                       | Tools     |
| -------------------------- | --------- |
| 実装後に覆せない選択を含む | `@Plan`   |
| 設計を練って提示する       | plan mode |

## Goal

設計を 1 つ提示し、`user` の承認を得よ。

承認を得るまで、code を書くな。file を作るな。`simplepowers-03-build` skill を呼ぶな。

## Next phase

承認が出たら `simplepowers-03-build` skill へ進め。
