---
name: issue
description: Create issue
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *), AskUserQuestion
---

# Issue

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする
2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る
3. `git remote get-url origin` で remote を判定し、ホストに応じて以下を実行する
   - **GitHub**: 以下を順に実行する（`--project "Board"` は同 org の Project しか参照できないため、cross-org でも動くよう 2 段階で行う）
     1. `URL=$(gh issue create --title "<title>" --body "<body>")` で issue を作成
     2. `gh project item-add 2 --owner yasainet --url "$URL"` で Personal Project (Board) に紐付け
   - **Gitea**: `tea issues create --remote origin --title "<title>" --description "<body>"`
4. 作成された issue の URL をユーザーに表示する
