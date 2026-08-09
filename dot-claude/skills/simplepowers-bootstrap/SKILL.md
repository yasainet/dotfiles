---
name: simplepowers-bootstrap
description: [Bootstrap] Simplepowers workflow
disable-model-invocation: true
---

# Simplepowers Bootstrap

> [!IMPORTANT]
>
> - 該当する phase の skill を起動せよ
> - 応答の冒頭で、現在の phase を宣言せよ

## Basic Workflow

| phase       | skill                  | next phase |
| ----------- | ---------------------- | ---------- |
| `[Explore]` | `simplepowers-explore` | `[Plan]`   |
| `[Plan]`    | `simplepowers-plan`    | `[Build]`  |
| `[Build]`   | `simplepowers-build`   | `[Verify]` |
| `[Verify]`  | `simplepowers-verify`  | `[Review]` |
| `[Review]`  | `simplepowers-review`  | `[Record]` |
| `[Record]`  | `simplepowers-record`  | -          |

- `[Build]` に入るには `user` の指示が要る。`[Explore]` や `[Plan]` から自分で移るな
- `[Build]` より後の連鎖は自分で進めてよい。自分の成果物を検証し、レビューに掛けよ
- `user` の直接の指示が最も強い。次が skill。既定の振る舞いは最も弱い

## Trigger Words

| English     | Japanese                       |
| ----------- | ------------------------------ |
| `[Explore]` | `調査`, `相談`, `協議`, `質問` |
| `[Plan]`    | `設計`, `方針`                 |
| `[Build]`   | `実装`, `修正`                 |
| `[Verify]`  | `検証`, `確認`                 |
| `[Review]`  | `レビュー`                     |
| `[Record]`  | `記録`, `commit`               |
