---
name: simplepowers-04-verify
description: [Verify]
---

# Verify

Start by declaring `[Verify]`.

## Purpose

`Build` で実装したコード・文章に対して、検証を実行せよ。

## Scope

- `Build` で実装したコード・文章に対して、検証を実行せよ
- 検証が失敗した場合、`Explore`, `Plan`, `Build` に戻れ

## Responsibilities

| When             | Tools                           |
| ---------------- | ------------------------------- |
| 検証の実行       | `./README.md` の Verify section |
| app の挙動を確認 | `/run`                          |

## Procedure

1. `./README.md` に Verify section がない場合、`user` に更新を促せ
2. 検証を実行し、出力と exit code を最後まで読め
3. 検証が失敗した場合、`Explore`, `Plan`, `Build` に戻れ
4. `Review` へ移行せよ

## References

N/A
