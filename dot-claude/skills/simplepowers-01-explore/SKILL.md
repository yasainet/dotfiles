---
name: simplepowers-01-explore
description: [Explore] コード、仕様、原因を調べる前に必ず使え。設計や実装より先に来る
---

# Explore

Start by declaring `[Explore]`.

## Purpose

`user` の問いに答える。答えた時点で完了。Explore は終点になりうる。

## Scope

- 全ての session はここから始まる
- 聞かれたことにだけ答えよ。修正案を添えるな
- 選択肢は `user` が決定を求めたときだけ出せ
- 次の phase へ誘導するな。設計に進むか聞くな

## Responsibilities

| When                                   | Tools                                 |
| -------------------------------------- | ------------------------------------- |
| 3 ファイル以内で済む                   | `Glob`, `Grep`, `Read`, `LSP`, `Bash` |
| 探索範囲が repo 全体や他の repo に及ぶ | `@Explore`                            |
| 命名規則が複数あり、横断的に洗い出す   | `@Explore`                            |
| 当てが付かず試行錯誤が要る             | `@general-purpose`                    |
| library の仕様を引く                   | `context7`, `WebSearch`               |
| URL が分かっている page を読む         | `WebFetch`                            |
| Claude Code の仕様を引く               | `claude-code-guide`                   |
| 様々な事例を深く調べる                 | `deep-research`                       |

## Procedure

1. library の仕様は記憶で答えず、Responsibilities の該当 tool で引け
2. 答えたら止まれ。`user` の指示を待て
3. `user` が設計や実装を指示したら、session の目的を 1 行で会話に示してから次へ移れ。file に残すな
