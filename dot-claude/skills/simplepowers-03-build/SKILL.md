---
name: simplepowers-03-build
description: [Build] コードを書く、ファイルを作る、設定を変えるときに使え。設計の承認を得た後に来る
---

# Build

Start by declaring `[Build]`.

## Previous phase

`user` が実装を指示したか確認せよ。指示が無いなら `simplepowers-02-plan` skill へ戻れ。

## Scope

- 承認された設計の範囲だけを作れ。広げるな
- 周囲のコードに合わせよ。comment の量、命名、書き方を揃えよ
- 途中で設計の穴に気付いたら、手を止めて `user` に伝えよ。黙って設計を変えるな

## Tools

| When                                  | Tools    |
| ------------------------------------- | -------- |
| 期待挙動を assertion として書ける変更 | `tdd.md` |

## Goal

承認された設計を全て作り終えよ。作ったものを列挙せよ。

動いたと言うな。検証は次の phase の仕事だ。

## Next phase

ここで止まれ。`user` の指示を待て。

`Verify` と `Review` は `default: off` だ。自分から入るな。
