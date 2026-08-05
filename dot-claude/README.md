# Claude Code

agent / skill / hooks について。

## Origin

built-in / plugin / custom の違い。

| origin   | where                      | git  |
| -------- | -------------------------- | ---- |
| built-in | Claude Code                | 不可 |
| plugin   | `~/.claude/plugins/cache/` | 外   |
| custom   | `dotfiles/dot-claude/`     | 下   |

## agent

`@name` で呼ぶ built-in agent。別 context で走り、結論だけ返る。

| name                 | use                                                          |
| -------------------- | ------------------------------------------------------------ |
| `@Explore`           | 読み取り専用の広域検索。多数のファイルを走査して結論だけ返す |
| `@general-purpose`   | 汎用。多段タスクや当てにくい検索に使う                       |
| `@Plan`              | 実装計画を立てる。手順と critical file を返す                |
| `@claude-code-guide` | Claude Code / Agent SDK / Claude API の仕様を答える          |
| `@statusline-setup`  | statusline を設定する                                        |
| `@claude`            | 種別を指定しないときの既定。全ツール                         |

## skill

`/name` で呼ぶ。現在の context に読み込まれる。

### built-in — develop

開発作業に利用する。`docs/workflow.md` で利用方法を定める。

| name               | use                                         |
| ------------------ | ------------------------------------------- |
| `/code-review`     | 手元の差分をレビューする                    |
| `/review`          | GitHub の PR をレビューする                 |
| `/security-review` | branch の変更を security 観点でレビューする |
| `/simplify`        | 変更箇所を整理して適用する。bug は探さない  |
| `/run`             | app を起動して変更の動作を確認する          |

### built-in — option

必要になったときだけ呼ぶ。

| name                        | use                                     |
| --------------------------- | --------------------------------------- |
| `/init`                     | CLAUDE.md を生成する                    |
| `/update-config`            | settings.json と hook を編集する        |
| `/keybindings-help`         | keybindings.json をカスタマイズする     |
| `/fewer-permission-prompts` | 許可プロンプトを減らす allowlist を作る |
| `/loop`                     | prompt や slash command を定期実行する  |
| `/schedule`                 | cron で動く cloud agent を管理する      |
| `/claude-api`               | Claude API と SDK の仕様を参照する      |
| `/claude-in-chrome`         | Chrome 操作の前に読む                   |
| `/dataviz`                  | グラフやダッシュボードを作る前に読む    |
| `/artifact-design`          | Artifact ページの設計指針               |
| `/artifact-diagramming`     | Artifact 内の図の描き方                 |
| `/artifact-capabilities`    | Artifact に持たせる実行時機能           |

### plugin

| plugin          | skill                             | use                                         |
| --------------- | --------------------------------- | ------------------------------------------- |
| commit-commands | `/commit-commands:commit`         | commit を作る                               |
| commit-commands | `/commit-commands:commit-push-pr` | commit から push、PR 作成まで通す           |
| commit-commands | `/commit-commands:clean_gone`     | remote で消えた branch を worktree ごと消す |
| context7        | -                                 | library の最新ドキュメントを引く            |

### custom

`skills/` に置く。

| name                     | use                            |
| ------------------------ | ------------------------------ |
| `/claude-yolo`           | 直前の回答を平易に書き直す     |
| `/claude-get-session-id` | session id を表示する          |
| `/git-bump`              | patch version tag を bump する |
| `/git-issue`             | GitHub / Gitea に issue を作る |
| `/supabase-migrate`      | Supabase の migration を通す   |

> [!TIP]
> `disable-model-invocation: true` で明示起動だけに限れる。5 個とも付けてある。

### vendor

ツール側が `skills/` に置いていくもの。

| name           | use                             |
| -------------- | ------------------------------- |
| `/herdr`       | terminal multiplexer を操作する |
| `/hunk-review` | 差分レビュー session を操作する |

## hooks

`hooks/` の shell を `settings.json` の event に紐づける。permission rule で書けない判断だけを持たせる。

### custom

| name                | event             | use                                            |
| ------------------- | ----------------- | ---------------------------------------------- |
| `guard-process.sh`  | PreToolUse(Bash)  | process と port を、所有者を見て止める         |
| `guard-delete.sh`   | PreToolUse(Bash)  | ファイル削除を `rm` から `trash` へ寄せる      |
| `inject-rules.sh`   | PreToolUse(W/E)   | 書き込み前に `rules/` の path 別規約を注入する |
| `on-prompt.sh`      | UserPromptSubmit  | 入力ソースを ABC に戻す                        |
| `on-needs-input.sh` | PermissionRequest | 入力ソースを ABC に戻す                        |

### vendor

ツール側が `hooks/` に置いていくもの。

| name                   | event        | use                           |
| ---------------------- | ------------ | ----------------------------- |
| `herdr-agent-state.sh` | SessionStart | herdr へ session の状態を渡す |
