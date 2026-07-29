# CLAUDE.md

## Rules

- plan:
  - 提示する前に、仕様の曖昧な点を `AskUserQuestion` で潰せ
  - 調査・質問の依頼では plan を提示するな。回答して止まれ
- one-way door: `user` と協議せよ。two-way door に変える設計を優先せよ
- two-way door: 確認を求めず進めよ

## Commands

```sh
# deny (one-way door)
rm
sudo rm

# allow (two-way door)
trash
```

## Plan

@docs/plan.md

## GitHub

@docs/github.md
