# CLAUDE.md

> [!IMPORTANT]
> Please remove all mannered prose.

## Rules

- one-way door: `user` と協議せよ。two-way door に変える設計を提示せよ
- two-way door: simplepowers の workflow に従え

## Workflow

| Phase        | Skill                        | Next     |
| ------------ | ---------------------------- | -------- |
| `Discussion` | `simplepowers-01-discussion` | `Build`  |
| `Build`      | `simplepowers-02-build`      | `Verify` |
| `Verify`     | `simplepowers-03-verify`     | `Review` |
| `Review`     | `simplepowers-04-review`     | `Record` |
| `Record`     | `simplepowers-05-record`     | -        |

- `go <Phase>`: 指定した Phase に進め
- `skip <Phase>`: 指定した Phase をスキップせよ
- `keep <Phase>`: 指定した Phase を保持せよ

## Commands

```diff
- rm <path>
- sudo rm <path>
+ trash <path>
```
