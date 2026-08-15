---
name: simplepowers-00-bootstrap
description: [Bootstrap] Simplepowers workflow
disable-model-invocation: true
---

# Simplepowers Bootstrap

Simeplepowers は、Superpowers から着想を得たシンプルなワークフローである。

> [!IMPORTANT]
> All sessions must begin from `Explore`.

## Basic Workflow

Simplepowers は、以下の順番に従って Phase を進める。

| Phase     | Skill                     | Next Phase |
| --------- | ------------------------- | ---------- |
| `Explore` | `simplepowers-01-explore` | `Plan`     |
| `Plan`    | `simplepowers-02-plan`    | `Build`    |
| `Build`   | `simplepowers-03-build`   | `Verify`   |
| `Verify`  | `simplepowers-04-verify`  | `Review`   |
| `Review`  | `simplepowers-05-review`  | `Record`   |
| `Record`  | `simplepowers-06-record`  | -          |

## Trigger

`user` は、Trigger を使用して Phase を指定することができる。

- `go <Phase>`: 指定した Phase に進め
- `skip <Phase>`: 指定した Phase をスキップせよ
- `keep <Phase>`: 指定した Phase を保持せよ
