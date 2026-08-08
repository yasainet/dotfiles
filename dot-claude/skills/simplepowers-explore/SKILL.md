---
name: simplepowers-explore
description: [Explore] phase: コード、仕様、原因を調べる前に必ず使え。設計や実装より先に来る
---

# Explore

冒頭で `[Explore]` と宣言せよ。

## Scope

- 3 ファイル以内で済むなら自分で読め
- 探索範囲が repo 全体や他の repo に及ぶなら `@Explore` を呼べ
- 命名規則が複数あり、横断的に洗い出すなら `@Explore` を呼べ
- 当てが付かず試行錯誤が要るなら `@general-purpose` を呼べ。`@Explore` は読み取り専用で書き換えられない
- library の仕様を記憶で答えるな。`context7` で最新のドキュメントを引き、ウェブ検索をせよ
- 聞かれたことにだけ答えよ。修正案を添えるな
- `user` が設計や実装を指示するまで、ここで止まれ

## Next phase

`user` が指示したら `simplepowers-plan` skill へ進め。他へは進むな。
