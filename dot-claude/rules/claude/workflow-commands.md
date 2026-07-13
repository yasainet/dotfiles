---
paths:
  - "**/dot-claude/commands/workflow/*.md"
---

# Workflow Command Rules

自分の開発ワークフローを構成するフェーズ command 群の作法。

## ワークフロー全体像

1. `/explore` で目的を合意し、調査する
2. 未確定事項があれば会話で協議する
3. plan mode に切り替えて計画を作成する（`docs/plans/*.md` に出力される）
4. plan ファイルを review・編集して承認する
5. `/implement` で検証ファーストの実装をする
6. `/code-review` と `/simplify` で review する
7. `/commit` で commit・PR を作成する
8. `/review #N` で PR review をする
9. `/clean_gone` で branch を整理する

## 設計原則

- 発動は人間が明示的に行う、`disable-model-invocation: true` を必ず付けよ
- plan の生成は標準 plan mode に委ね、command で再実装するな
- subagent へ委譲するときは model を必ず明示せよ
- 成果物は短く定型に保て、読まれない出力は作るな
- 検証を通すまで完了を宣言するな

> [!NOTE]
> この内容を `commands/workflow/CLAUDE.md` に置くと、
> `/CLAUDE` という余計な command として登録されてしまう。
> `commands/` 配下の `.md` はすべて command になるため、rule として持つ。
