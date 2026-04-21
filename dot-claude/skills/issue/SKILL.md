---
name: issue
description: Create issue
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *), AskUserQuestion
---

# Issue

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする
2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る
3. `git remote get-url origin` で remote を判定し、ホストに応じて以下を実行する
   - **GitHub**: `gh issue create --project "Board" --title "<title>" --body "<body>"`
   - **Gitea**: `tea issues create --remote origin --title "<title>" --description "<body>"`
4. 作成された issue の URL をユーザーに表示する
