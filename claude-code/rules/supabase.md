---
paths:
  - "**/supabase/**"
---

# Supabase Rules

This project uses [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas).
Edit `supabase/schemas/*.sql` to declare the desired state; migrations are generated via `supabase db diff --local` or `supabase db push --local`.

## Migration

- **Don't** edit `migrations/*.sql` files
- **Don't** run `apply_migration` with `supabase-mcp`
- **Don't** run `supabase db diff` yourself
- **Don't** run `supabase db reset` yourself
- **Don't** run `supabase gen types` yourself
- **Do** tell the user to run `/migrate <name>` after editing `*.schema.sql`
