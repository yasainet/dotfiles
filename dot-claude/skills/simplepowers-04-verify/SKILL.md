---
name: simplepowers-04-verify
description: [Verify] user が検証を指示したときに使え。実装の後、レビューの前に来る
---

# Verify

Start by declaring `[Verify]`.

## Previous phase

実装を終えたか確認せよ。終えていないなら `simplepowers-03-build` skill へ戻れ。

## Scope

- 出力と exit code を最後まで読め
- 失敗したなら、出力をそのまま示せ。隠すな
- 飛ばした検証があるなら、飛ばしたと言え
- README.md に Verify section が無いなら、コマンドを自分で特定し、section の追加を `user` に促せ

## Tools

| When                   | Tools                                 |
| ---------------------- | ------------------------------------- |
| 検証コマンドを実行する | repo root README.md の Verify section |
| app の挙動を確認する   | `/run`                                |

## Goal

証拠なしに完了と言うな。

このターンで検証コマンドを実行していないなら、通ったとは言えない。

失敗が残るなら `simplepowers-03-build` skill へ戻れ。

## Next phase

通ったらここで止まれ。`user` の指示を待て。
