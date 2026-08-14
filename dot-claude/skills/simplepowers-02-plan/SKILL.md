---
name: simplepowers-02-plan
description: [Plan] 実装方針を決めるときに使え。調査の後、実装の前に来る
---

# Plan

Start by declaring `[Plan]`.

## Purpose

実装方針を 1 つに決め、`user` の承認を得る。承認が完了条件。

## Scope

- 調査を終えてから適用する。足りないなら `Explore` へ戻れ
- 承認を得るまで、code を書くな。file を作るな
- 案を並べるな。推奨を 1 つ出せ

## Responsibilities

| When                       | Tools     |
| -------------------------- | --------- |
| 実装後に覆せない選択を含む | `@Plan`   |
| 設計を練って提示する       | plan mode |

## Procedure

1. one-way door を含むなら `user` と協議し、two-way door に変える設計を提示せよ
2. 設計を 1 つ提示せよ。却下した案があるなら、理由を 1 行で添えよ
3. `user` の承認を待て。承認なしに `Build` へ進むな
