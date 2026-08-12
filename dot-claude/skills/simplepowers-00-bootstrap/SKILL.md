---
name: simplepowers-00-bootstrap
description: [Bootstrap] Simplepowers workflow
disable-model-invocation: true
---

# Simplepowers Bootstrap

> [!IMPORTANT]
> All sessions must begin from `Explore`.

## Basic Workflow

| phase     | skill                     | next phase | default |
| --------- | ------------------------- | ---------- | ------- |
| `Explore` | `simplepowers-01-explore` | `Plan`     | on      |
| `Plan`    | `simplepowers-02-plan`    | `Build`    | on      |
| `Build`   | `simplepowers-03-build`   | `Verify`   | on      |
| `Verify`  | `simplepowers-04-verify`  | `Review`   | off     |
| `Review`  | `simplepowers-05-review`  | `Record`   | off     |
| `Record`  | `simplepowers-06-record`  | -          | on      |

- `default` は trigger word がないときの既定値だ。`on` は通る、`off` は通らない
- phase は文脈から解釈して移れ。迷ったら現在の phase に留まれ
- `Build` と `default: off` の phase には自分から入るな。`go <phase>` か明確な指示を待て
- `Record` で、通らなかった phase を申告せよ
- `user` の直接の指示が最も強い。次が trigger word。次が skill。既定の振る舞いは最も弱い

## Trigger Words

基本は文脈からの解釈に任せる。細かい制御が必要なとき `user` が発動する。

| trigger        | 意味                                                |
| -------------- | --------------------------------------------------- |
| `go <phase>`   | その phase へ移れ。後戻りを含む                     |
| `skip <phase>` | その phase を飛ばして次へ移れ。`Record` で申告せよ  |
| `keep <phase>` | その phase に留まれ。次の `go` まで遷移を提案するな |
