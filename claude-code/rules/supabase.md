---
paths:
  - "**/supabase/schemas/*.sql"
  - "**/supabase/migrations/*.sql"
  - "**/supabase/seeds/**/*.sql"
  - "**/supabase/config.toml"
---

# Supabase Rules

## Migration

- Don't Use: execute `apply_migration` with `supabase-mcp`
- After editing `*.schema.sql` → tell the user to run `/migrate <name>`
