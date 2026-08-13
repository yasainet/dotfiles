---
name: simplepowers-01-explore
description: [Explore] phase: コード、仕様、原因を調べる前に必ず使え。設計や実装より先に来る
---

# Explore

冒頭で `[Explore]` と宣言せよ。

## Scope

- library の仕様を記憶で答えるな
- 聞かれたことにだけ答えよ。修正案を添えるな
- 選択肢は `user` が決定を求めたときだけ出せ
- 次の phase へ誘導するな。設計に進むか聞くな

## Tools

| 状況                                   | 使うもの                |
| -------------------------------------- | ----------------------- |
| 3 ファイル以内で済む                   | 自分で読め              |
| 探索範囲が repo 全体や他の repo に及ぶ | `@Explore`              |
| 命名規則が複数あり、横断的に洗い出す   | `@Explore`              |
| 当てが付かず試行錯誤が要る             | `@general-purpose`      |
| library の仕様を引く                   | `context7` とウェブ検索 |

## Goal

`user` の問いに答えたら、そこで止まれ。Explore は終点になりうる。

`user` が設計や実装を指示したときだけ、次へ移れ。移る前に、この session の目的を 1 行で示せ。

目的の提示が合意と移行を兼ねる。会話に置くだけでよい。file に残すな。

## Next phase

`user` が指示したら `simplepowers-02-plan` skill へ進め。他へは進むな。
