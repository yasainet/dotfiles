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
- `## Development Flow`: superpowers の発動点とプロジェクト原則の接続点 (詳細は superpowers skill へ委譲)
- `## Docs Structure`: living / frozen / scaffold / scratch の 4 区分の所在と性質 (詳細は superpowers-scaffold rule へ委譲)
- `## Commands`: プロジェクト固有のコマンド
- `## Verification`: コード変更後に動作を確認するコマンド (verification-before-completion 規律を含む)
- `## Glossaries`: optional / プロジェクト固有の用語、定義
```

> [!NOTE]
> Development Flow と Docs Structure は接続点だけを書け。
> フローの詳細は superpowers skill が、docs の書き分け詳細は scaffold rule が持つ。
> CLAUDE.md は委譲先のリンクとプロジェクト固有の例外だけを書く。
