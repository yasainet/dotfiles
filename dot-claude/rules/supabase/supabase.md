---
paths:
  - "**/supabase/**"
---

# Supabase Rules

- Supabase / Supabase CLI についてのルール。

## Directory Structure

```text
  supabase/
  ├── .env.sample        # config.toml env()
  ├── .env               # config.toml env()
  ├── config.toml
  ├── migrations/
  ├── schemas/           # Declarative database schemas
  │   ├── .pgdelta-export.json
  │   ├── _cluster/
  │   │   ├── extensions/        # <extension>.sql
  │   │   └── roles.sql
  │   ├── _custom/
  │   └── <schema>/              #  public/
  │       ├── schema.sql
  │       ├── default_privileges.sql
  │       └── <NN>_<name>.sql    # ex: 01_users.sql
  ├── seeds/
  │   ├── *.seed.sql             # ex: 01_users.seed.sql
  │   ├── storages/              # ex: 01.storage.seed.sql
  │   │   └── <bucket_name>/
  │   └── scripts/
  │       ├── *.local.sql
  │       └── *.production.sql   # Run manually
  ├── snippets/
  ├── templates/
  └── functions/         # Supabase Edge Functions
      ├── .env.sample
      └── .env
```

## Declarative database schemas / 宣言的データベーススキーマ

[Declarative database schema](https://supabase.com/docs/guides/local-development/declarative-database-schemas) を利用せよ。

1. 宣言: `supabase/schemas/<schema>/<NN>_<name>.sql` に宣言せよ
   - 拡張は `supabase/schemas/_cluster/extensions/<extension>.sql`
2. 生成: `supabase db schema declarative sync --name <name> --apply` で生成せよ
3. 型生成: `supabase gen types typescript --local > src/lib/supabase/types.ts` を生成せよ
4. 反映: `supabase db push` で反映せよ
