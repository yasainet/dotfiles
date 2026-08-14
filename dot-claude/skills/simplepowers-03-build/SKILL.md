---
name: simplepowers-03-build
description: [Build] コードを書く、ファイルを作る、設定を変えるときに使え。設計の承認を得た後に来る
---

# Build

Start by declaring `[Build]`.

## Purpose

承認された設計を作り切る。検証はしない。

## Scope

- `user` が実装を指示してから適用する。指示が無いなら `Plan` へ戻れ
- 承認された設計の範囲だけを作れ。広げるな
- 動いたと言うな。検証は `Verify` の仕事だ

## Procedure

1. 期待挙動を assertion として書ける変更は、`tdd.md` の手順に従え
2. 周囲のコードに合わせよ。comment の量、命名、書き方を揃えよ
3. 設計の穴に気付いたら、手を止めて `user` に伝えよ。黙って設計を変えるな
4. 作ったものを列挙して止まれ。`user` の指示を待て

## References

- [tdd.md](tdd.md): TDD の手順書
