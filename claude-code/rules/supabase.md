---
paths:
  - "**/supabase/**"
---

# Supabase Rules

This project uses [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas).
Edit `supabase/schemas/*.sql` to declare the desired state; migrations are generated via `supabase db diff --local` or `supabase db push --local`.

## Migration

- Don't Use: execute `apply_migration` with `supabase-mcp`
- After editing `*.schema.sql` → tell the user to run `/migrate <name>`
