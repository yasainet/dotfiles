---
name: issue
description: [Skills] Crate issue to GitHub/Gitea
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *), AskUserQuestion
---

# Issue

## ルール

- 本文は HEREDOC (`cat <<'EOF' ... EOF`) で記述せよ
- `label` / `assignee` / `milestone` など、metadata は付与しない

## 手順

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする

2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る

3. remote を判定する

```bash
git remote get-url origin
```

4. GitHub の場合は issue を作成し、Personal Project #2 (Board) に紐付ける

```bash
URL=$(gh issue create --title "<title>" --body "<body>")
gh project item-add 2 --owner yasainet --url "$URL"
```

5. Gitea の場合は issue を作成する

```bash
tea issues create --remote origin --title "<title>" --description "<body>"
```

6. 作成された issue の URL をユーザーに表示する
