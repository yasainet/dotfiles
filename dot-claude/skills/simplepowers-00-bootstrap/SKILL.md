---
name: simplepowers-00-bootstrap
description: [Bootstrap] Simplepowers workflow
disable-model-invocation: true
---

# Simplepowers Bootstrap

> [!IMPORTANT]
> All sessions must begin from `Explore`.

## Basic Workflow

| Phase     | Skill                     | Next Phase | Default |
| --------- | ------------------------- | ---------- | ------- |
| `Explore` | `simplepowers-01-explore` | `Plan`     | on      |
| `Plan`    | `simplepowers-02-plan`    | `Build`    | on      |
| `Build`   | `simplepowers-03-build`   | `Verify`   | on      |
| `Verify`  | `simplepowers-04-verify`  | `Review`   | off     |
| `Review`  | `simplepowers-05-review`  | `Record`   | off     |
| `Record`  | `simplepowers-06-record`  | -          | on      |

- `Default` は Trigger がないときの既定値だ。`on` は通る、`off` は通らない
- `Build` と `Default: off` の Phase には自分から入るな。`go <Phase>` か明確な指示を待て
- `user` の直接の指示が最も強い。次が Trigger。次が Skill。既定の振る舞いは最も弱い

## Trigger

基本は文脈からの解釈に任せる。細かい制御が必要なとき `user` が発動する。

| Trigger        | 意味                            |
| -------------- | ------------------------------- |
| `go <Phase>`   | その Phase へ移れ。後戻りを含む |
| `skip <Phase>` | その Phase を飛ばして次へ移れ   |
| `keep <Phase>` | その Phase に留まれ             |
