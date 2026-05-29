---
paths:
  - "**/*.md"
---

# Markdown Rules

## Headings

- 見出し要素の上下に、区切り線 `---` の利用を禁止する

## Styling text

- 1 文 1 行、一文一義を原則とせよ
  - 日本語: 1 文は 60 文字以内を推奨する
  - English: 1 sentence は 20 words 以内を推奨する
- `**Bold**` の利用は禁止する

## Quoting text

- 後述する `Alerts` の活用を推奨する

## Task lists

- Task lists / TODO は `- [ ]` (未完了), `- [x]` (完了) のタスクリスト記法を利用せよ
- ネストは 2 スペースを利用せよ

## Alerts

- 以下のパターンのみ使用を許可する

```Markdown samaple.md
> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!TODO]
> Tasks or action items that need to be completed.
```

## Table

- 1 行 80 桁を超える場合は、table の利用を禁止する
