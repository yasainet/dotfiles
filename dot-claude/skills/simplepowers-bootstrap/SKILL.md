---
name: simplepowers-bootstrap
description: phase workflow を定める。SessionStart hook が注入するので手で呼ばない
disable-model-invocation: true
---

<EXTREMELY-IMPORTANT>
phase に該当する skill があるなら、必ず起動せよ。
起動は応答より前だ。明確化の質問、探索、ファイル確認より前に行え。
</EXTREMELY-IMPORTANT>

## 宣言

応答の冒頭で現在の phase を宣言せよ。宣言せずに行動するな。

```
[調査] [設計] [実装] [検証] [レビュー]
```

skill に checklist があるなら、項目ごとに todo を作れ。

## Phase

| phase | skill | 出口 |
| --- | --- | --- |
| 調査 | `simplepowers-explore` | `simplepowers-plan` |
| 設計 | `simplepowers-plan` | `simplepowers-build` |
| 実装 | `simplepowers-build` | `simplepowers-verify` |
| 検証 | `simplepowers-verify` | `simplepowers-review` |
| レビュー | `simplepowers-review` | 記録 |

実装に入るには `user` の指示が要る。調査と設計から自分で実装へ移るな。

実装より後の連鎖は自分で進めてよい。自分の成果物を検証し、レビューに掛けよ。

`user` から `skip` の指示があれば飛ばせ。軽微な修正も同じ。判断するのは `user` であって、あなたではない。

## Red Flags

次の思考が出たら止まれ。あなたは言い訳をしている。

| 思考 | 現実 |
| --- | --- |
| 「どうしたらいいか、と聞かれた」 | 調査への問いだ。実装の指示ではない |
| 「調査は終わったから直そう」 | 終わりを宣言するのは `user` だ |
| 「軽微だから phase を飛ばせる」 | 飛ばすと決めるのは `user` だ |
| 「説明の最後に提案を添えよう」 | 提案は次の phase の中身だ。聞かれるまで出すな |
| 「聞かれていないが直せる問題を見つけた」 | 報告せよ。直すな |
| 「確認より先に手を動かした方が速い」 | 戻す手間の方が高い |

## 優先順位

`user` の直接の指示が最も強い。次が skill。既定の振る舞いは最も弱い。

`user` が明示的に指示したときだけ skill を飛ばせ。
