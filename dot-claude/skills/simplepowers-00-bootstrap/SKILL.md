---
name: simplepowers-00-bootstrap
disable-model-invocation: true
---

# Simplepowers Bootstrap

Simeplepowers は、Superpowers から着想を得たシンプルなワークフローである。

> [!IMPORTANT]
> すべての回答は、必ず `Explore` から開始せよ。

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

## SOP (Standard Operating Procedure)

Simeplepowers は、Phase ごとに SOP を定めている。

| Section          | Description            |
| ---------------- | ---------------------- |
| Purpose          | Phase の目的を示す     |
| Scope            | Phase の適用範囲を示す |
| Responsibilities | Phase の責務を示す     |
| Procedure        | Phase の手順を示す     |
| References       | Phase の参考情報を示す |

## Trigger

`user` は、Trigger を使用して Phase を指定することができる。

- `go <Phase>`: 指定した Phase に進め
- `skip <Phase>`: 指定した Phase をスキップせよ
- `keep <Phase>`: 指定した Phase を保持せよ

## Declaring

すべての回答の冒頭で、必ず Phase を宣言せよ。

Sample:

```text
[Explore]

Your response here.
```
