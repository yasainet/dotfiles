---
name: issue
description: GitHub / Gitea に issue を起票する。「issue 作成」「issue 起票」「起票して」「issue 立てて」「issue 化して」「これ issue にして」等、issue 作成を要求する発話があれば必ずこの skill を起動する。`/issue` の明示呼び出しがなくても、文脈から起票意図が読み取れる場合は proactively に起動すること。判断保留事項・調査依頼・クライアント確認事項を issue にする場合も同様。
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *), AskUserQuestion
---

# Issue

## ルール

- **付与する**: Board (Project #2) への紐付けを常に行うこと
- **付与しない**: label / assignee / milestone など、metadata は付与しない

本文は HEREDOC (`cat <<'EOF' ... EOF`) で記述する（single quote 付きなのでバックスラッシュ escape 不要）

## 手順

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする
2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る
3. `git remote get-url origin` で remote を判定し、ホストに応じて以下を実行する
   - **GitHub**: 以下を順に実行する（`--project "Board"` は同 org の Project しか参照できないため、cross-org でも動くよう 2 段階で行う）
     1. `URL=$(gh issue create --title "<title>" --body "<body>")` で issue を作成
     2. `gh project item-add 2 --owner yasainet --url "$URL"` で Personal Project (Board) に紐付け
   - **Gitea**: `tea issues create --remote origin --title "<title>" --description "<body>"`
4. 作成された issue の URL をユーザーに表示する
