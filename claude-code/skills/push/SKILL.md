---
name: push
description: Push current branch. With --tag, also increment the latest tag and push it
argument-hint: [--tag]
allowed-tools: Bash(git *)
---

# Push

Arguments: $ARGUMENTS

Latest tag: `!git describe --tags --abbrev=0`

## Instructions

1. `git push`

If `$ARGUMENTS` contains `--tag`, also do:

2. Increment the **patch** version of the latest tag (e.g., `v0.0.0` → `v0.0.1`)
3. `git tag vX.X.X`
4. `git push origin vX.X.X`
