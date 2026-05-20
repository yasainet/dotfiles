# CLAUDE.md

## Communication

- 結論ファースト。挨拶・前置き・要約の復唱は不要
- 指摘・反論は率直に。同意のための同意をするな
- 確証のない推測した事項を断定するな

## Verification Triggers

回答・実装の前に必ず一次ソースを調査、検索せよ

- ローカル状態
  → `Bash` / `Read` / `Glob` / `Grep` で調査、検索
- ライブラリ・SDK・API・CLI の現行仕様
  → `Context7` / 公式ドキュメントを参照
- コマンドのフラグ・挙動
  → `--help` / `man` / docs を参照

## Workflow Defaults

次の手順に従い実行せよ: 調査、計画、実装、検証、更新

- 調査: ゴール達成に必要な関連ファイル、一次ソースを調査、検索せよ
- 計画: `EnterPlanMode` ツールを呼び出して Plan Mode に入り、TODO を提案せよ
  - 自明な編集の場合、Plan Mode を省略可能
- 実装: TODO に従って実装せよ
  - 新機能 / DB 変更を伴う変更は、次の layer ごとに `実装 → 検証 → commit` を完結させてから次へ進め
  - 該当する変更がない layer は省略可能
    1. infra (`supabase/migrations/*`, `supabase/seed.sql`, `supabase/*`)
    2. backend (`src/features/*`, `src/lib/*`, `src/utils/*`)
    3. api (`src/app/api/**/route.ts`)
    4. frontend (`src/components/*`, `src/app/**/page.tsx`)
    5. tests (`tests/*`, e2e)
    6. metadata (`src/app/sitemap.ts`, `src/app/robots.ts`, OG image, `next.config.ts`)
    7. docs (`docs/**/*.md`)
  - PR は機能単位であり 1 feature = 1 PR
  - commit は layer 単位を原則とする
  - 軽微な単発修正は、layer 分割を省略可能
- 検証: プロジェクトの `CLAUDE.md` で定義された `Verification` を実行せよ
- 更新: `docs/**/*.md`, `**/*.md` など、必要に応じて更新をせよ
