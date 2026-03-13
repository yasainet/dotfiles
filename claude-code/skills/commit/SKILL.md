---
name: commit
description: Review changes and create a commit with a generated message
allowed-tools: Bash(git *), Bash(gh issue list *), AskUserQuestion
---

# Commit

## Instructions

1. Run `git status`. If there are no uncommitted changes, inform the user and stop
2. Run `git diff` (and `git diff --cached` if there are staged changes) to review the actual changes
3. Run `git log --oneline -5` to check the existing commit message style
4. Run `gh issue list --state open` to check for related open issues
   - If a related issue exists, include `Closes #N` in the commit message footer
5. **Security check**: If any sensitive files are being committed (e.g. `.env`, `.env.local`, `credentials.json`, `*.pem`, `*.key`, `secret*`), warn the user and confirm before proceeding
6. Stage changes using individual file paths (`git add <file1> <file2> ...`), not `git add -A`
7. Generate a concise commit message following the style from step 3. Do NOT include `Co-Authored-By` or any signature trailers
8. Use the `AskUserQuestion` tool to ask the user with these options:
   - Use the generated message (show it in the label)
   - Cancel
