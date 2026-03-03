---
paths:
  - "claude-code/docs/**/*.md"
---

# Docs Markdown Rules

## Frontmatter

- Every document MUST have a YAML frontmatter block
- Required fields:
  - `status`: `draft` or `published`
  - `date`: creation date in `YYYY-MM-DD` format

```yaml
---
status: draft
date: 2026-03-03
---
```
