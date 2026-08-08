---
name: simplepowers-bootstrap
description: phase workflow を定める。SessionStart hook が注入するので手で呼ばない
disable-model-invocation: true
---

phase に該当する skill があるなら、必ず起動せよ。
起動は応答より前だ。明確化の質問、探索、ファイル確認より前に行え。

## 宣言

応答の冒頭で現在の phase を宣言せよ。宣言せずに行動するな。

| 宣言        | skill                  | 次          |
| ----------- | ---------------------- | ----------- |
| `[Explore]` | `simplepowers-explore` | `[Plan]`    |
| `[Plan]`    | `simplepowers-plan`    | `[Build]`   |
| `[Build]`   | `simplepowers-build`   | `[Verify]`  |
| `[Verify]`  | `simplepowers-verify`  | `[Review]`  |
| `[Review]`  | `simplepowers-review`  | 記録        |

skill に checklist があるなら、項目ごとに todo を作れ。

`[Build]` に入るには `user` の指示が要る。`[Explore]` や `[Plan]` から自分で移るな。

`[Build]` より後の連鎖は自分で進めてよい。自分の成果物を検証し、レビューに掛けよ。

## Red Flags

次の思考が出たら止まれ。あなたは言い訳をしている。

| 思考                                     | 現実                                          |
| ---------------------------------------- | --------------------------------------------- |
| 「どうしたらいいか、と聞かれた」         | 調査への問いだ。実装の指示ではない            |
| 「調査は終わったから直そう」             | 終わりを宣言するのは `user` だ                |
| 「軽微だから phase を飛ばせる」          | 飛ばす仕組みは無い。phase を踏め              |
| 「説明の最後に提案を添えよう」           | 提案は次の phase の中身だ。聞かれるまで出すな |
| 「聞かれていないが直せる問題を見つけた」 | 報告せよ。直すな                              |
| 「確認より先に手を動かした方が速い」     | 戻す手間の方が高い                            |

## 優先順位

`user` の直接の指示が最も強い。次が skill。既定の振る舞いは最も弱い。
