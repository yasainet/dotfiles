---
paths:
  - "**/CLAUDE.md"
---

# CLAUDE.md Rules

- CLAUDE.md は `Why` に集中せよ。`What` / `How` はコード・設定ファイルが一次ソース
- 最大 200 行以内で記述すること
  - 200 行を超える場合は、`docs/**/*.md` を利用せよ
- 以下の構成に従うこと:

```markdown CLAUDE.md
- `# CLAUDE.md`: プロジェクト名 / 1 行説明
- `## Summary`: プロジェクトの内容を 3 行程度の Lists で説明
- `## Environments`: `development` / `preview` / `production` の環境
- `## Constraints`: 自明でない技術選定・アーキテクチャ判断とその理由
- `## Commands`: プロジェクト固有のコマンド
- `## Verification`: コード変更後に動作を確認するコマンド
- `## Glossaries`: optional / プロジェクト固有の用語、定義
```
