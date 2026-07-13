# TL;DR

- 自分の 9 ステップ開発ワークフローを dotfiles の command / rule として確立する
- 新規作成は `commands/implement.md` の 1 ファイルのみ
- plan フェーズは標準 plan mode に委ね、`rules/docs/plan.md` の拡張で成果物を定型化する
- `commands/explore.md` の `/plan` 参照を plan mode 参照に修正する

## Context

superpowers の調査から、良さ（フェーズ構造・TDD・subagent の model 使い分け）と
不満（hook による自動発動・重い成果物）の原因を分離できた。
発動の主導権を人間に置き、既存の標準機能と資産に乗る最小構成を作る。
`settings.json` に `plansDirectory: ./docs/plans` が設定済みのため、
plan の生成・review・承認は標準 plan mode がそのまま担える。

## ワークフロー全体像

| ステップ | 担当 |
|---|---|
| 1. 目的共有・調査 | `/explore`（作成済み） |
| 2. 協議 | 会話（explore の出口分岐） |
| 3-4. plan 作成・承認 | 標準 plan mode + rule 拡張 |
| 5. 実装 | `/implement`（本計画で新規作成） |
| 6. review | `/code-review` + `/simplify`（既存） |
| 7. commit・PR | `commit-commands`（既存） |
| 8. PR review | `/review`（既存） |
| 9. branch 整理 | `clean_gone`（既存） |

## 変更内容

### 1. `dot-claude/rules/docs/plan.md` を拡張

固定フォーマットと行数上限を追記し、脳死承認を防ぐ。

- 構成を「TL;DR → 目的 → 変更ファイル → 手順 → 検証」に固定せよ
- 全体 40 行以内とせよ
- 手順は番号付きリストで、1 タスク 1 行とせよ
- 検証には実行可能なコマンドまたは確認手順を書け

### 2. `dot-claude/commands/implement.md` を新規作成

frontmatter は `description` + `disable-model-invocation: true`。
編集を伴うため `allowed-tools` による制限は設けない。

Steps の骨子:

1. 承認済み plan（`docs/plans/*.md`、`$ARGUMENTS` で指定可）を読む
2. 着手前に検証方法を宣言する
   - テスト可能なロジック → TDD で実装する
   - 設定・script・UI → 実行ベースの検証手順を明示する
3. TDD の場合は red → green → refactor を厳守する
   - 失敗するテストを先に書き、失敗を確認してから実装せよ
   - テストより先に書いた実装コードは破棄せよ
4. 機械的なタスクは subagent に委譲し、model を必ず明示する
   - 判断を伴う実装は sonnet、機械的な変更は haiku
5. 宣言した検証を全て通してから完了を報告する

NOTE: 検証を通さずに完了を宣言するな。
行き詰まったら同じ方法で再試行せず、状況を報告して相談せよ。

### 3. `dot-claude/commands/explore.md` を修正

- Steps 5 の「/plan」参照を「plan mode に切り替えて計画を作成」に変更
- NOTE の「それは /plan の仕事である」を「それは plan mode の仕事である」に変更

## 作らないもの

- `/plan` command（標準 plan mode + plansDirectory + rule で足りる）
- review 系 command（既存 `/code-review` と `/simplify` に任せる）
- タスクごとの内包レビュー（superpowers 式は重複するため不採用）

## 検証

- [ ] 新規セッションで `/implement` が一覧に出て、自動発動しないことを確認
- [ ] 小さな実際のタスクで `/explore` → plan mode → `/implement` を通しで実行
- [ ] plan mode の成果物が docs/plans/ に固定フォーマットで生成されるか確認
- [ ] TDD 分岐と実行ベース検証分岐の両方を 1 回ずつ試す

> [!WARNING]
> settings.json が参照する hooks/inject-path-rule.mjs が repo 内に見当たらない。
> rule 拡張が Write 時に注入されるかは検証項目で確認し、必要なら別途対応する。
