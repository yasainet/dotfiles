---
name: bump
description: Bump patch version tag
allowed-tools: Bash(git *)
---

# Bump

1. 最新 tag を取得

```bash
git describe --tags --abbrev=0
```

2. patch をインクリメント (`v0.1.0` → `v0.1.1`)

3. tag を作成

```bash
git tag vX.X.X
```

4. tag を push

```bash
git push origin vX.X.X
```
