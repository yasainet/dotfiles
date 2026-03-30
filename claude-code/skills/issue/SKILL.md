---
name: issue
description: Create a GitHub issue and add it to the Board project
allowed-tools: Bash(gh *), AskUserQuestion
---

# Issue

## Instructions

1. If the user provided a title and body, use them directly. Otherwise, ask the user for the issue title and description
2. Run `gh issue create --project "Board" --title "<title>" --body "<body>"` in the current repository
3. Show the created issue URL to the user
