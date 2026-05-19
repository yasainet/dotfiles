---
paths:
  - "**/*.md"
---

# Markdown Rules

## Headings

- 見出し要素の上下に、区切り線 `---` は、禁止する

## Styling text

- 100桁以内に抑えよ
- 100桁以上になる場合は `Lists` を利用せよ
- `Bold`, `Italic` の利用は禁止する

## Links

- リンクは `[text](url)` のインラインリンクを利用せよ

## Lists

- `-` で統一し、ネストは 2 スペースを利用せよ

## Alerts

- ユーザーの成功に不可欠な場合にのみ使用し、読者の負担を軽減した利用をせよ

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

- 100桁以上になる場合は、視認性が下がるので `Lists`, `Headings` の利用を検討せよ

## TODO

- TODO は `- [ ]` (未完了), `- [x]` (完了) のタスクリスト記法を利用せよ
- ネストは 2 スペースを利用せよ
