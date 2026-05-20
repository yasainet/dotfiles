---
name: bump
description: Bump patch version tag
allowed-tools: Bash(git *)
---

# Bump

1. 最新タグを取得: `!git describe --tags --abbrev=0`
2. 最新タグの patch をインクリメントする: `v0.1.0` → `v0.1.1`
3. `git tag vX.X.X`
4. `git push origin vX.X.X`
