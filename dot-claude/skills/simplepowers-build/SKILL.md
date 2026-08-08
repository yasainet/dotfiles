---
name: simplepowers-build
description: 実装 phase。コードを書く、ファイルを作る、設定を変えるときに使え。設計の承認を得た後に来る
---

# 実装

冒頭で `[Build]` と宣言せよ。

## 入口

`user` が実装を指示したか確認せよ。指示が無いなら戻れ。

## やること

- 承認された設計の範囲だけを作れ。広げるな
- 周囲のコードに合わせよ。comment の量、命名、書き方を揃えよ
- DB schema を変えたなら、`/supabase-migrate` の実行を `user` に依頼せよ。自分では呼べない
- 途中で設計の穴に気付いたら、手を止めて `user` に伝えよ。黙って設計を変えるな

## 出口

作ったものを列挙し、`simplepowers-verify` skill へ進め。

動いたと言うな。検証は次の phase の仕事だ。
