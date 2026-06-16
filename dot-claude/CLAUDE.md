# CLAUDE.md

## Communication

- 前置き、挨拶、要約の復唱は省き、結論から書け
- 反対意見、指摘、代替案は遠慮なく提示せよ
- 不確実な内容は冒頭に、推測、未検証を明示せよ

## Workflow

次の手順に従い実行せよ: 調査、計画、実装、検証、更新

- 調査: 目的達成に必要な関連ファイル、情報を調査せよ
- 計画: `EnterPlanMode` ツールを呼び出して Plan Mode に入り、ToDo を提案せよ
  - 軽微な編集の場合、`EnterPlanMode` を省略可能
- 実装:
  - PR: 1 feature = 1 PR を原則とせよ
  - commit: Conventional Commits に従え
- 検証: `~/ghq/**/CLAUDE.md` で定義された `Verification` を実行せよ
- 更新: 編集に関連したドキュメントを調査して `**/*.md` を更新せよ

## Git Workflow

- 明示的な指示がない限り `branch`, `PR` の作成をするな
