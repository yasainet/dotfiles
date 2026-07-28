# ai-commit-msg.sh: 生成メッセージへの前置き混入を修正

## Context

lazygit から `ai-commit-msg.sh` を実行すると、生成結果にコミットメッセージ以外の文が混ざる:

```
  これはコミットメッセージ生成の依頼で、plan モードの調査・計画は不要です。差分から直接メッセージを作成します。

change(dot-claude): plan ルールを追加、settings.json のモデル/権限設定を更新
```

原因は `claude -p` がユーザー設定を丸ごと継承していること:

- `dot-claude/settings.json:21` の `"defaultMode": "plan"` により plan モードで起動 → 「plan は不要です」という前置きが出る
- `dot-claude/CLAUDE.md` の plan ルール、`hooks.UserPromptSubmit`、outputStyle なども読み込まれ、応答が汚れる

結果として `MSG` が多行になり、そのまま `git commit -m "$MSG"` されると壊れたコミットメッセージになる。

狙い: 生成を「素の Claude + 差分だけ」の状態で走らせ、前置きが出る原因そのものを消す。

## 変更対象

`.config/lazygit/ai-commit-msg.sh` のみ。

### 1. `generate()` の `claude` フラグを差し替え (8-24 行目)

```sh
  } | MAX_THINKING_TOKENS=0 claude \
    -p "Based on the above changes, create a single git commit message for the staged changes. Output only the commit message on a single line, following the style of the recent commits. Do not send any other text besides the message." \
    --model haiku \
    --safe-mode \
    --permission-mode manual \
    --tools "" \
    --no-session-persistence \
    --strict-mcp-config --mcp-config '{"mcpServers":{}}'
```

- `--safe-mode`: CLAUDE.md・hooks・plugins・MCP・skills・outputStyle を無効化（auth / model / permissions は通常どおり動く）
- `--permission-mode manual`: settings.json の `defaultMode: plan` を上書き（今回の前置きの直接原因）
- `--tools ""`: 全ビルトインツールを無効化。既存の `--disallowed-tools "Bash,Read,..."` 列挙を置き換え、列挙漏れもなくなる
- `--no-session-persistence`: 生成ごとのセッション履歴をディスクに残さない
- `--strict-mcp-config --mcp-config` は `--safe-mode` と重複するが、保険としてそのまま残す

これ以外（ループ、空文字チェック、プロンプト文言）は変更しない。出力の後処理は入れない — 原因を潰すのが目的で、前置きが再発したら気付ける方がよい。

## 検証

このリポジトリの未コミット変更で確認済み（`claude 2.1.220`）。同じ入力で前置きなしの 1 行が返ることを確認:

```
change(dot-claude): CLAUDE.md と settings.json を更新
```

実運用の確認手順:

1. 適当な変更を作る（未コミット状態）
2. `sh ~/.config/lazygit/ai-commit-msg.sh` を実行
   - 注意: 冒頭で `git add -A` するため全ファイルがステージされる
3. 表示が 1 行のメッセージのみになっていることを確認し、`q` でキャンセル
4. 必要なら `git reset` でステージを戻す
5. lazygit のカスタムコマンドからも同様に実行して確認
