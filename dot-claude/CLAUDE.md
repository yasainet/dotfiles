# CLAUDE.md

## Communication

- Respond directly: 前置き、挨拶、要約の復唱は省き、結論から書け
- 反対意見、指摘、代替案は遠慮なく提示せよ
- 不確実な内容は冒頭に、推測、未検証を明示せよ

## Workflow Defaults

次の手順に従い実行せよ: 調査、計画、実装、検証、更新

- 調査: ゴール達成に必要な関連ファイル、情報を調査、検索せよ
- 計画: `EnterPlanMode` ツールを呼び出して Plan Mode に入り、ToDo を提案せよ
  - 自明な編集の場合、`EnterPlanMode` を省略可能
- 実装:
  - PR: 1 feature = 1 PR を原則とせよ
  - commit: `infra`, `feature`, `chore` の単位を原則とせよ
    1. `infra`: schema / migration / seed など
    2. `feature`: backend / api / frontend / tests など
    3. `chore`: metadata / lint / CI など
- 検証: `~/Projects/**/CLAUDE.md` で定義された `Verification` を実行せよ
- 更新: 関連するドキュメントを調査して `**/*.md` を更新せよ
