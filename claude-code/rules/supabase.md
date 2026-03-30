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

## Secrets Management

| Mechanism               | Config Location                                                   | Scope                                 | Access                         |
| ----------------------- | ----------------------------------------------------------------- | ------------------------------------- | ------------------------------ |
| **Vault Secrets**       | `config.toml` `[db.vault]` + root `.env`                          | SQL (pg_cron, triggers, functions)    | `vault.decrypted_secrets` view |
| **Edge Functions env**  | `supabase/functions/.env` (local) / `supabase secrets set` (prod) | Edge Functions                        | `Deno.env.get()`               |
| **config.toml `env()`** | root `.env`                                                       | config.toml values (auth, smtp, etc.) | `env(VAR_NAME)`                |

## Seeds & Scripts

```toml
[db.migrations]
schema_paths = ["./schemas/*.sql"]

[db.seed]
sql_paths = ["./seeds/*.seed.sql", "./seeds/**/*.seed.sql", "./seeds/scripts/*.local.sql"]

```

- `supabase/seeds/**/*.seed.sql` — Seed files (auto-executed on `db reset`)
- `supabase/seeds/storages/*.storage.seed.sql` — Storage bucket seed files (RLS policies, bucket creation)
- `supabase/seeds/scripts/*.local.sql` — Local environment setup (auto-executed on `db reset` via `sql_paths`)
- `supabase/seeds/scripts/*.production.sql` — Production environment setup (manual execution only, excluded from seed)
- `supabase/seeds/storages/<bucket_name>/` — Seed asset files for storage buckets (images, etc.)

## Directory Structure

```text
.env                   # Vault secrets for config.toml env()
supabase/
├── config.toml        # Supabase configuration ([db.vault] reads from root .env)
├── migrations/        # Auto-generated migration files (DO NOT edit)
├── schemas/           # Declarative schema definitions (numbered: 01_users.schema.sql)
├── seeds/             # Seed data (auto-executed on db reset)
│   ├── *.seed.sql             # Table seed data (numbered: 01_users.seed.sql)
│   ├── storages/              # Storage bucket seeds (*.storage.seed.sql)
│   │   └── <bucket_name>/            # Seed asset files (e.g. users/**/default.jpg)
│   └── scripts/               # Environment scripts (optional)
│       ├── *.local.sql                # Local setup (auto-executed on db reset)
│       └── *.production.sql           # Production setup (manual execution only)
├── snippets/          # SQL snippets (optional)
├── templates/         # Templates (optional)
└── functions/         # Supabase Edge Functions (optional)
    └── .env           # Edge Functions secrets (gitignored)
```

### Example `.env`

```.env ~/Projects/**/.env
# Vault Secrets
VAULT_SUPABASE_URL=
VAULT_SERVICE_ROLE_KEY=

# Run the Terminal
#
# Production
# VAULT_SUPABASE_URL=https:*.supabase.co
# VAULT_SERVICE_ROLE_KEY=
```

```.env ~/Projects/**/supabase/functions/.env
# Edge Function Secrets
ENVIRONMENT=development

# Run the Terminal
#
# Production
# supabase secrets set ENVIRONMENT=production --project-ref wwfdzwjhjzuwjcgchqhl

```
