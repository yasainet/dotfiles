---
paths:
  - "**/supabase/**"
---

# Supabase Rules

- Declarative Database Schemas を採用する

## Migration

- `*.schema.sql` 編集後は、ユーザーに `/migrate <name>` を実行するよう伝えよ

## Secrets Management

- Vault Secrets
  - 設定場所: `config.toml` `[db.vault]` + ルートの `.env`
  - スコープ: SQL（pg_cron、トリガー、関数）
  - アクセス方法: `vault.decrypted_secrets` view
- Edge Functions env
  - 設定場所: `supabase/functions/.env` development / `supabase secrets set` production
  - スコープ: Edge Functions
  - アクセス方法: `Deno.env.get()`
- config.toml `env()`
  - 設定場所: ルートの `.env`
  - スコープ: config.toml の値（auth、smtp 等）
  - アクセス方法: `env(VAR_NAME)`

## Seeds & Scripts

```toml supabase/comfig.toml
[db.migrations]
schema_paths = ["./schemas/*.sql"]

[db.seed]
sql_paths = [
  "./seeds/*.seed.sql",
  "./seeds/**/*.seed.sql",
  "./seeds/scripts/*.local.sql",
]
```

- `supabase/seeds/**/*.seed.sql` — Seed files
- `supabase/seeds/storages/*.storage.seed.sql` — Storage seed files / RLS policy
- `supabase/seeds/scripts/*.local.sql` — Setup scripts for development
- `supabase/seeds/scripts/*.production.sql` — Setup scripts for production (run manually)
- `supabase/seeds/storages/<bucket_name>/` — Asset files for storage seed

## Directory Structure

```text
.env                   # config.toml env() 用の Vault シークレット
supabase/
├── config.toml        # Supabase 設定（[db.vault] はルートの .env を読む）
├── migrations/        # 自動生成されるマイグレーションファイル（編集禁止）
├── schemas/           # 宣言的スキーマ定義（番号付き: 01_users.schema.sql）
├── seeds/             # シードデータ（db reset 時に自動実行）
│   ├── *.seed.sql             # テーブルのシード（番号付き: 01_users.seed.sql）
│   ├── storages/              # ストレージのシード（*.storage.seed.sql）
│   │   └── <bucket_name>/     # シードアセット（例: default.jpg）
│   └── scripts/               # 環境スクリプト（任意）
│       ├── *.local.sql        # ローカル（db reset 時に自動実行）
│       └── *.production.sql   # 本番（手動実行のみ）
├── snippets/          # SQL スニペット（任意）
├── templates/         # テンプレート（任意）
└── functions/         # Supabase Edge Functions（任意）
    └── .env           # Edge Functions のシークレット（gitignore 対象）
```

### Example

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
# supabase secrets set ENVIRONMENT=production --project-ref <project-id>
```

## References

- [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas)
