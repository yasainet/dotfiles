---
name: publish
description: Push to main. With --tag, also increment the latest tag and push it
argument-hint: [--tag]
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Publish

Arguments: $ARGUMENTS

Latest tag: `!git describe --tags --abbrev=0`

## Instructions

Run all commands sequentially without confirmation:

1. If `git status` shows uncommitted changes, run `git add -A && git commit -m "update"`. Otherwise skip
2. `git push origin main`

If `$ARGUMENTS` contains `--tag`, also do:

3. Increment the **patch** version of the latest tag (e.g., `v0.0.0` → `v0.0.1`)
4. `git tag vX.X.X`
5. `git push origin vX.X.X`
