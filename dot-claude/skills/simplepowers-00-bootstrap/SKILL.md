---
name: simplepowers-00-bootstrap
description: Simplepowers Bootstrap
disable-model-invocation: true
---

# Simplepowers Bootstrap

## Basic Workflow

以下の順番に従って Phase を進める。

| Phase     | Skill                     | Next Phase |
| --------- | ------------------------- | ---------- |
| `Explore` | `simplepowers-01-explore` | `Plan`     |
| `Plan`    | `simplepowers-02-plan`    | `Build`    |
| `Build`   | `simplepowers-03-build`   | `Verify`   |
| `Verify`  | `simplepowers-04-verify`  | `Review`   |
| `Review`  | `simplepowers-05-review`  | `Record`   |
| `Record`  | `simplepowers-06-record`  | -          |

## Template

Phase ごとに以下の Section を定める。

| Section | Description                         |
| ------- | ----------------------------------- |
| Do      | Phase でやることを示す              |
| Don't   | Phase でやらないことを示す          |
| Done    | Phase の終了条件と次の Phase を示す |

## Trigger

`user` は、Trigger を使用して Phase を指定する。

- `go <Phase>`: 指定した Phase に進め
- `skip <Phase>`: 指定した Phase をスキップせよ
- `keep <Phase>`: 指定した Phase を保持せよ
