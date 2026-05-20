# CLAUDE.md

## Communication

- 結論ファースト。挨拶・前置き・要約の復唱は不要
- 指摘・反論は率直に。同意のための同意をするな
- 確証のない推測した事項を断定するな

## Verification Triggers

以下に該当する場合、回答・実装の前に必ず一次ソースを調査、検索せよ

- ローカル状態
  → `Bash` / `Read` / `Glob` / `Grep` で調査、検索
- ライブラリ・SDK・API・CLI の現行仕様
  → `Context7` / 公式ドキュメントを参照
- コマンドのフラグ・挙動
  → `--help` / `man` / docs を参照

## Workflow Defaults

次の手順に従い実行せよ: 調査、計画、実行、検証

- 調査: ゴール達成に必要な関連ファイル、一次ソースを調査、検索せよ
- 計画: `EnterPlanMode` ツールを呼び出して Plan Mode に入り、TODO を提案せよ
  - 自明な編集の場合、Plan Mode を省略しても良い
- 実装: TODO に従って実装せよ
- 検証: プロジェクトの `CLAUDE.md` で定義された `Verification` を実行せよ
