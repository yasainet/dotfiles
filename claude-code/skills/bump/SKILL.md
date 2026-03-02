---
name: bump
description: Push to main, increment the latest tag, and push the new tag to trigger CI publish
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Bump

Latest tag: `!git describe --tags --abbrev=0`

## Instructions

Increment the **patch** version of the latest tag (e.g., `v0.0.0` → `v0.0.1`) and run all commands sequentially without confirmation:

1. If `git status` shows uncommitted changes, run `git add -A && git commit -m "vX.X.X"`. Otherwise skip
2. `git push origin main`
3. `git tag vX.X.X`
4. `git push origin vX.X.X`
