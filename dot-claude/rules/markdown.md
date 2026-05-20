---
paths:
  - "**/*.md"
---

# Markdown Rules

## Headings

- 見出し要素の上下に、区切り線 `---` の利用を禁止する

## Styling text

- 100 桁以上になる場合は `Lists` を利用せよ

  ```json
  "sentence-length": {"max": 100}
  ```

- `()` の多用を避けて、入れ子にした `Lists` を推奨する
- **Bold**, _Italic_ の利用は禁止する

## Quoting text

- 後述する `Alerts` の活用を推奨する

## Task lists

- Task lists / TODO は `- [ ]` (未完了), `- [x]` (完了) のタスクリスト記法を利用せよ
- ネストは 2 スペースを利用せよ

## Alerts

- ユーザーの成功に不可欠な場合にのみ、以下のパターンのみ使用せよ

```Markdown samaple.md
> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!TODO]
> Tasks or action items that need to be completed.
```
