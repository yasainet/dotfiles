---
name: issue
description: GitHub issue を作成し、Board プロジェクトに追加する
allowed-tools: Bash(gh *), AskUserQuestion
---

# Issue

1. ユーザーがタイトルと本文を指定している場合は、それをそのまま使用する
2. 指定がない場合は、現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする
3. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る
4. カレントリポジトリで `gh issue create --project "Board" --title "<title>" --body "<body>"` を実行する
5. 作成された issue の URL をユーザーに表示する
