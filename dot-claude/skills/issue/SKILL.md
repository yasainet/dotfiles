---
name: issue
description: Crate issue to GitHub/Gitea
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *), AskUserQuestion
---

# Issue

## ルール

- 本文は HEREDOC (`cat <<'EOF' ... EOF`) で記述せよ
- `label` / `assignee` / `milestone` など、metadata は付与しない

## 手順

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする
2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る
3. `git remote get-url origin` で remote を判定し、`GitHub` / `Gitea `に応じて以下を実行する
   - GitHub:
     - `URL=$(gh issue create --title "<title>" --body "<body>")` で issue を作成
     - `gh project item-add 2 --owner yasainet --url "$URL"` で Personal Project #2 (Board) に紐付け
   - Gitea:
     `tea issues create --remote origin --title "<title>" --description "<body>"`
4. 作成された issue の URL をユーザーに表示する
