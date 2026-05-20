---
paths:
  - "**/CLAUDE.md"
  - "!**/.claude/CLAUDE.md"
  - "!**/dot-claude/CLAUDE.md"
---

# CLAUDE.md ルール

- CLAUDE.md は `Why` に集中せよ。`What` / `How` はコード・設定ファイルが一次ソース
- 以下の構成に従うこと:

```markdown
1. `# CLAUDE.md`: プロジェクト名 / 1行説明
2. `## Summary`: プロジェクトの内容を 3行程度の Lists で説明
3. `## Constraints`: 自明でない技術選定・アーキテクチャ判断とその理由
4. `## Verification`: コード変更後に動作を確認するコマンド
```
