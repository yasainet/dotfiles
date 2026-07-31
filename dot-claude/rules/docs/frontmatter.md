---
paths:
  - "**/docs/*.md"
  - "**/docs/**/*.md"
  - "**/notes/*.md"
  - "**/notes/**/*.md"
---

# Frontmatter Rules

- 以下のディレクトリは除外する
  - `~/.claude/**/*.md`
  - `~/ghq/github.com/yasainet/dotfiles/dot-claude/**/*.md`
- 項目は `created` と `updated` の2つ

```md
---
created: 1986-08-11 # yyyy-mm-dd
updated: 2000-01-01 # yyyy-mm-dd
---
```
