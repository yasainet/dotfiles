# README

agent / skill / command がどこ由来で、どこにあるかを整理する

## 3 つの由来

| 由来     | 実体の場所                 | git 管理 | 更新                      |
| -------- | -------------------------- | -------- | ------------------------- |
| built-in | Claude Code 本体に同梱     | 不可     | 本体の update に追従      |
| plugin   | `~/.claude/plugins/cache/` | 外       | plugin の update で上書き |
| 自前     | `dotfiles/dot-claude/`     | 下       | 自分で書く                |

built-in は消せない。plugin は改変しても上書きされる。自前だけが自分の資産になる

## 呼び出し方

| type    | run           | context                         |
| ------- | ------------- | ------------------------------- |
| agent   | `name` を指定 | 別 context で走る。結論だけ返る |
| skill   | `/name`       | 現在の context に読み込まれる   |
| command | `/name`       | 同上                            |

## built-in agent

| name                | use                                                          |
| ------------------- | ------------------------------------------------------------ |
| `Explore`           | 読み取り専用の広域検索。多数のファイルを走査して結論だけ返す |
| `Plan`              | 実装計画を立てる。手順と critical file を返す                |
| `general-purpose`   | 汎用。多段タスクや当てにくい検索に使う                       |
| `claude`            | 種別を指定しないときの既定。全ツール                         |
| `claude-code-guide` | Claude Code / Agent SDK / Claude API の仕様を答える          |
| `statusline-setup`  | statusline の設定                                            |

## built-in skill

| name                        | use                                         |
| --------------------------- | ------------------------------------------- |
| `/review`                   | GitHub の PR をレビューする                 |
| `/security-review`          | branch の変更を security 観点でレビューする |
| `/simplify`                 | 変更箇所を整理して適用する。bug は探さない  |
| `/run`                      | app を起動して変更の動作を確認する          |
| `/init`                     | CLAUDE.md を生成する                        |
| `/loop`                     | prompt や slash command を定期実行する      |
| `/schedule`                 | cron で動く cloud agent を管理する          |
| `/update-config`            | settings.json と hook を編集する            |
| `/keybindings-help`         | keybindings.json をカスタマイズする         |
| `/fewer-permission-prompts` | 許可プロンプトを減らす allowlist を作る     |
| `/claude-api`               | Claude API と SDK の仕様を参照する          |
| `/claude-in-chrome`         | Chrome 操作の前に読む                       |
| `/dataviz`                  | グラフやダッシュボードを作る前に読む        |
| `/artifact-design`          | Artifact ページの設計指針                   |
| `/artifact-diagramming`     | Artifact 内の図の描き方                     |
| `/artifact-capabilities`    | Artifact に持たせる実行時機能               |

## built-in command

- `/code-review` — 作業差分をレビューする。`ultra` で multi-agent 版
- `/config` `/help` `/fast` `/clear` など CLI 組み込み

## plugin

| plugin          | 提供物        | 呼び方                         |
| --------------- | ------------- | ------------------------------ |
| commit-commands | command 3 個  | `/commit-commands:commit` など |
| context7        | MCP tool 2 個 | tool として自動                |

## 自前 (dot-claude/)

agent は持たない。built-in で足りる

### commands/ — 5 個

- `/claude:get-session-id` `/claude:yolo`
- `/github:bump` `/github:issue`
- `/supabase:migrate`

### skills/ — 2 個

- `herdr` — terminal multiplexer の操作
- `hunk-review` — 差分レビュー session の操作。brew の hunk 本体への symlink

### その他

- `docs/` — CLAUDE.md から `@` で読み込む規約群
- `rules/` — hook が Write/Edit 時に注入する規約
- `hooks/` `output-styles/` `scripts/`

## 紛らわしいもの

- `/review` と `/code-review` — 前者は GitHub の PR、後者は手元の差分
- `/code-review` と `/simplify` — 前者は bug を探す、後者は品質だけ見る
- `Explore` と `Plan` — 前者は探す、後者は方針を立てる
- `Explore` と `general-purpose` — 前者は読み取り専用、後者は書き込みも可能

## workflow

どの phase で何を呼ぶかは `docs/workflow.md` に定める
