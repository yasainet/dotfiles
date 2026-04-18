---
paths:
  - "**/supabase/**"
---

# Supabase Rules

このプロジェクトは [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas) を使用している。
`supabase/schemas/*.sql` を編集して目的の状態を宣言し、マイグレーションは `supabase db diff --local` または `supabase db push --local` で生成する。

## Migration

- `migrations/*.sql` ファイルを**編集しない**こと
- `supabase-mcp` で `apply_migration` を**実行しない**こと
- `supabase db diff` を自分で**実行しない**こと
- `supabase db reset` を自分で**実行しない**こと
- `supabase gen types` を自分で**実行しない**こと
- `*.schema.sql` 編集後は、ユーザーに `/migrate <name>` を実行するよう**伝える**こと

## Secrets Management

| 仕組み                  | 設定場所                                                              | スコープ                          | アクセス方法                   |
| ----------------------- | --------------------------------------------------------------------- | --------------------------------- | ------------------------------ |
| **Vault Secrets**       | `config.toml` `[db.vault]` + ルートの `.env`                          | SQL（pg_cron、トリガー、関数）    | `vault.decrypted_secrets` view |
| **Edge Functions env**  | `supabase/functions/.env`（ローカル）/ `supabase secrets set`（本番） | Edge Functions                    | `Deno.env.get()`               |
| **config.toml `env()`** | ルートの `.env`                                                       | config.toml の値（auth、smtp 等） | `env(VAR_NAME)`                |

## Seeds & Scripts

```toml
[db.migrations]
schema_paths = ["./schemas/*.sql"]

[db.seed]
sql_paths = ["./seeds/*.seed.sql", "./seeds/**/*.seed.sql", "./seeds/scripts/*.local.sql"]

```

- `supabase/seeds/**/*.seed.sql` — シードファイル（`db reset` 時に自動実行）
- `supabase/seeds/storages/*.storage.seed.sql` — ストレージバケットのシードファイル（RLS ポリシー、バケット作成）
- `supabase/seeds/scripts/*.local.sql` — ローカル環境セットアップ（`sql_paths` 経由で `db reset` 時に自動実行）
- `supabase/seeds/scripts/*.production.sql` — 本番環境セットアップ（手動実行のみ、シードからは除外）
- `supabase/seeds/storages/<bucket_name>/` — ストレージバケット用のシードアセットファイル（画像など）

## Directory Structure

```text
.env                   # config.toml env() 用の Vault シークレット
supabase/
├── config.toml        # Supabase 設定（[db.vault] はルートの .env を読む）
├── migrations/        # 自動生成されるマイグレーションファイル（編集禁止）
├── schemas/           # 宣言的スキーマ定義（番号付き: 01_users.schema.sql）
├── seeds/             # シードデータ（db reset 時に自動実行）
│   ├── *.seed.sql             # テーブルのシードデータ（番号付き: 01_users.seed.sql）
│   ├── storages/              # ストレージバケットのシード（*.storage.seed.sql）
│   │   └── <bucket_name>/            # シードアセットファイル（例: users/**/default.jpg）
│   └── scripts/               # 環境スクリプト（任意）
│       ├── *.local.sql                # ローカルセットアップ（db reset 時に自動実行）
│       └── *.production.sql           # 本番セットアップ（手動実行のみ）
├── snippets/          # SQL スニペット（任意）
├── templates/         # テンプレート（任意）
└── functions/         # Supabase Edge Functions（任意）
    └── .env           # Edge Functions のシークレット（gitignore 対象）
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
