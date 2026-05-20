---
paths:
  - "**/*.md"
---

# Markdown Rules

## Headings

- 見出し要素の上下に、区切り線 `---` は、禁止する

## Styling text

- 80~100 桁以内に抑えよ
- 100 桁以上になる場合は `Lists` を利用せよ
- **Bold**, _Italic_ の利用は禁止する

## Quoting text

- 後述する `Alerts` の活用を推奨する

## Task lists

- Task lists / TODO は `- [ ]` (未完了), `- [x]` (完了) のタスクリスト記法を利用せよ
- ネストは 2 スペースを利用せよ

## Alerts

- ユーザーの成功に不可欠な場合にのみ使用せよ

```Markdown samaple.md
> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

> [!TODO]
> Tasks or action items that need to be completed.

```

## Table

- 1 行が 100 桁以上になる場合は、視認性が下がるので `Lists`, `Headings` を利用せよ
