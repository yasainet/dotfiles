---
name: simplepowers-02-plan
description: Simplepowers Plan
---

# Plan

## Do

- `Explore` で決めた目的 (Goal) を `./.claude/plans/<kebab-case>-<yyyymmdd>.md` として書け
- 以下のテンプレートに従って書け

```markdown
# Title

## Summary

- Goal:

## Files

- Create: `path`
- Modify: `path`
- Delete: `path`
```

> [!NOTE]
>
> - 出力された `./.claude/plans/*.md` に対して、 `user` は、`>` で注釈を書く
> - 注釈に従って、`./.claude/plans/*.md` を修正し、再提示せよ

## Don't

- `./.claude/plans/*.md` 以外のファイルの編集を禁止する

## Done

- `user` が `Plan` を承認したら `TaskCreate` して、`Build` へ移行せよ

## Tools

| When          | Tools        |
| ------------- | ------------ |
| `Plan` を承認 | `TaskCreate` |
