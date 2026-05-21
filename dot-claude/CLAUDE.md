# CLAUDE.md

## Communication

- 結論ファースト。挨拶・前置き・要約の復唱は不要
- 指摘・反論は率直に。同意のための同意をするな
- 確証のない推測した事項を断定するな

## Workflow Defaults

次の手順に従い実行せよ: 調査、計画、実装、検証、更新

- 調査: ゴール達成に必要な関連ファイル、情報を調査、検索せよ
- 計画: `EnterPlanMode` ツールを呼び出して Plan Mode に入り、ToDo を提案せよ
  - 自明な編集の場合、`EnterPlanMode` を省略可能
- 実装: ToDo に従って実装せよ
  - PR: 1 feature = 1 PR を原則とせよ
  - commit: `infra`, `feature`, `chore` の単位を原則とせよ
    1. infra:
       - `supabase/*`
    2. feature:
       - backend: `src/features/*`, `src/lib/*`, `src/utils/*`
       - api: `src/app/api/**/route.ts`
       - frontend: `src/components/*`, `src/app/**/page.tsx`
       - tests: `tests/*`
       - metadata: `src/app/sitemap.ts`, `src/app/robots.ts`, OG image など
    3. chore:
       - `next.config.ts`, lint, tooling, CI など
- 検証: プロジェクトの `CLAUDE.md` で定義された `Verification` を実行せよ
- 更新: 必要に応じて関連するドキュメントを調査して `**/*.md` を更新せよ
