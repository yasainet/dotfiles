---
name: commit
description: Review changes and create a commit with a generated message
allowed-tools: Bash(git *)
---

# Commit

## Instructions

1. Run `git status`. If there are no uncommitted changes, inform the user and stop
2. Review the diff and generate a concise commit message
3. Ask the user with these options:
   - Use the generated message (show it in the label)
   - Cancel
   - Enter custom message (user types their own)
4. Commit the changes
