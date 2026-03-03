---
name: publish
description: Push current branch. With --tag, also increment the latest tag and push it
argument-hint: [--tag]
allowed-tools: Bash(git *)
---

# Publish

Arguments: $ARGUMENTS

Latest tag: `!git describe --tags --abbrev=0`

## Instructions

1. Run `git status`. If there are no uncommitted changes, skip to step 4
2. Review the diff and generate a concise commit message
3. Ask the user with these options:
   - Use the generated message (show it in the label)
   - Cancel
   - Enter custom message (user types their own)
4. `git push`

If `$ARGUMENTS` contains `--tag`, also do:

5. Increment the **patch** version of the latest tag (e.g., `v0.0.0` → `v0.0.1`)
6. `git tag vX.X.X`
7. `git push origin vX.X.X`
