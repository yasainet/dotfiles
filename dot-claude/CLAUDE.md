# CLAUDE.md

> [!IMPORTANT]
> Please remove all mannered prose.

## Rules

- one-way door: `user` と協議せよ。two-way door に変える設計を提示せよ
- two-way door: Workflow に従え

## Workflow

Discussion -> Build -> Verify -> Review -> Record の順に進めよ。

| Phase      | Do                                     | Don't            |
| ---------- | -------------------------------------- | ---------------- |
| Discussion | Goal を達成するために調査、協議せよ    | ファイルの編集   |
| Build      | Discussion で合意した Goal を実装せよ  | 合意した変更以外 |
| Verify     | `./README.md` の Verify section に従え | -                |
| Review     | `/code-review`                         | -                |
| Record     | @docs/github.md                        | -                |

- `go <Phase>`: 指定した Phase に進め
- `skip <Phase>`: 指定した Phase をスキップせよ
- `keep <Phase>`: 指定した Phase を保持せよ

## Commands

```diff
- rm <path>
- sudo rm <path>
+ trash <path>
```
