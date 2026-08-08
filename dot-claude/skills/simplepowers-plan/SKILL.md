---
name: simplepowers-plan
description: [Plan] phase: 実装方針を決めるときに使え。調査の後、実装の前に来る
---

# Plan

冒頭で `[Plan]` と宣言せよ。

## Previous phase

調査を終えたか確認せよ。足りないなら `simplepowers-explore` skill へ戻れ。

## やること

- 案を並べるな。推奨を 1 つ出せ
- 却下した案があるなら、理由を 1 行で添えよ
- one-way door を含むなら `user` と協議せよ。two-way door に変える設計を提示せよ
- 実装後に覆せない選択を含むときだけ `@Plan` を呼べ
- plan mode を使ってよい。設計はその本来の用途だ
- 設計を提示し、`user` の承認を得よ
- 承認を得るまで、コードを書くな。ファイルを作るな
- 承認を得るまで、`simplepowers-build` skill を呼ぶな

## Next phase

承認が出たら `simplepowers-build` skill へ進め。
