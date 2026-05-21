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
- 実装: ToDo に従って実装せよ
  - PR: 1 feature = 1 PR を原則とせよ
  - commit: `infra`, `feature`, `chore` の単位を原則とせよ
    1. infra: スキーマ変更・migration・seed など取り消し困難な状態変更
    2. feature: vertical slice として 1 commit にまとめ、end-to-end で検証可能な状態にする
       - 対象: backend / api / frontend / tests / metadata など
    3. chore: 横断的な設定・基盤の変更
       - 対象: build config, lint, CI, tooling など
- 検証: プロジェクトの `CLAUDE.md` で定義された `Verification` を実行せよ
- 更新: 必要に応じて関連するドキュメントを調査して `**/*.md` を更新せよ
