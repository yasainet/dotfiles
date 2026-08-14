---
name: simplepowers-04-verify
description: [Verify] user が検証を指示したときに使え。実装の後、レビューの前に来る
---

# Verify

Start by declaring `[Verify]`.

## Purpose

検証コマンドを実行し、通った証拠を得る。証拠なしに完了と言わない。

## Scope

- 実装を終えてから適用する。終えていないなら `Build` へ戻れ
- このターンで実行していない検証は、通ったと言えない
- 失敗の修正はここでするな。`Build` の仕事だ

## Responsibilities

| When                   | Tools                                 |
| ---------------------- | ------------------------------------- |
| 検証コマンドを実行する | repo root README.md の Verify section |
| app の挙動を確認する   | `/run`                                |

## Procedure

1. README.md に Verify section が無いなら、コマンドを自分で特定し、section の追加を `user` に促せ
2. 検証コマンドを実行し、出力と exit code を最後まで読め
3. 失敗したなら、出力をそのまま示せ。隠すな。修正は `Build` へ戻れ
4. 飛ばした検証があるなら、飛ばしたと言え
5. 結果を報告して止まれ。`user` の指示を待て
