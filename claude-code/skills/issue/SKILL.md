---
name: issue
description: Create a GitHub issue and add it to the Board project
allowed-tools: Bash(gh *), AskUserQuestion
---

# Issue

## Instructions

1. If the user provided a title and body, use them directly
2. Otherwise, summarize the current conversation context to draft an appropriate issue title and body
3. Show the drafted title and body to the user for confirmation before creating
4. Run `gh issue create --project "Board" --title "<title>" --body "<body>"` in the current repository
5. Show the created issue URL to the user
