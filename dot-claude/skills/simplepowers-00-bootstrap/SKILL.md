---
name: simplepowers-00-bootstrap
description: [Bootstrap] Simplepowers workflow
disable-model-invocation: true
---

# Simplepowers Bootstrap

> [!IMPORTANT]
>
> - 該当する phase の skill を起動せよ
> - 応答の冒頭で、現在の phase を宣言せよ

## Basic Workflow

| phase       | skill                     | next phase | optional |
| ----------- | ------------------------- | ---------- | -------- |
| `[Explore]` | `simplepowers-01-explore` | `[Plan]`   |          |
| `[Plan]`    | `simplepowers-02-plan`    | `[Build]`  |          |
| `[Build]`   | `simplepowers-03-build`   | `[Verify]` |          |
| `[Verify]`  | `simplepowers-04-verify`  | `[Review]` | yes      |
| `[Review]`  | `simplepowers-05-review`  | `[Record]` | yes      |
| `[Record]`  | `simplepowers-06-record`  | -          |          |

- `[Build]` に入るには `user` の指示が要る。`[Explore]` や `[Plan]` から自分で移るな
- `optional` の phase は `user` の trigger word でだけ起動せよ。自分から入るな
- `[Record]` で、飛ばした optional phase を申告せよ
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
