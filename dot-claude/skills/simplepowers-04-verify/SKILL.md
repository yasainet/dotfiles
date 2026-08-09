---
name: simplepowers-04-verify
description: [Verify] phase: user が検証を指示したときに使え。実装の後、レビューの前に来る
---

# Verify

冒頭で `[Verify]` と宣言せよ。

## Previous phase

実装を終えたか確認せよ。終えていないなら `simplepowers-03-build` skill へ戻れ。

## Scope

1. repo root の README.md の Verify コマンドを実行せよ
2. app の挙動を確認する必要がある場合は `/run` を実行せよ

- 出力と exit code を最後まで読め
- 失敗したなら、出力をそのまま示せ。隠すな
- 飛ばした検証があるなら、飛ばしたと言え
- Verify section が無いなら、コマンドを自分で特定し、section の追加を `user` に促せ

## Goal

証拠なしに完了と言うな。

このターンで検証コマンドを実行していないなら、通ったとは言えない。

失敗が残るなら `simplepowers-03-build` skill へ戻れ。

## Next phase

通ったらここで止まれ。`user` の指示を待て。
