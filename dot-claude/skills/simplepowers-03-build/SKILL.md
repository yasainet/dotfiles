---
name: simplepowers-03-build
description: Simplepowers Build
---

# Build

## Do

- TDD で書け。1 振る舞いごとに以下を繰り返せ
  - Red: 失敗する test を書き、失敗することを確認せよ
  - Green: test を通す最小の実装を書け
  - Refactor: test を通したまま整えよ
- `TaskCreate` された `Plan` を実装せよ
- `TaskList`, `TaskUpdate` で進捗を提示せよ

## Don't

- `Plan` にはない変更を禁止する。必要なら `user` に伝えて `Explore` に戻れ
- test を通すために test を弱めるな。仕様に寄せて実装を直せ
- 不要なコメント、JSDoc を追加するな

## Done

- 実装を終えたら `Verify` へ移行せよ

## Tools

| When         | Tools        |
| ------------ | ------------ |
| Tasks を表示 | `TaskList`   |
| Tasks を更新 | `TaskUpdate` |
