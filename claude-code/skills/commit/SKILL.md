---
name: commit
description: Review changes and create a commit with a generated message
allowed-tools: Bash(git *)
---

# Commit

## Instructions

1. Run `git status`. If there are no uncommitted changes, inform the user and stop
2. Run `git diff` (and `git diff --cached` if there are staged changes) to review the actual changes
3. Run `git log --oneline -5` to check the existing commit message style
4. **Security check**: If any sensitive files are being committed (e.g. `.env`, `.env.local`, `credentials.json`, `*.pem`, `*.key`, `secret*`), warn the user and confirm before proceeding
5. Stage changes using individual file paths (`git add <file1> <file2> ...`), not `git add -A`
6. Generate a concise commit message following the style from step 3
7. Ask the user with these options:
   - Use the generated message (show it in the label)
   - Cancel
   - Enter custom message (user types their own)
