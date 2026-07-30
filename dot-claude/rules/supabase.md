---
paths:
  - "**/supabase/**"
---

# Supabase Rules

- Declarative Database Schemas を採用する

## Migration

- `*.schema.sql` を編集したら、`/supabase:migrate <name>` を自ら実行せよ

### Basic Workflow

1. 宣言 — `supabase/schemas/*.schema.sql` に「あるべき状態」を書く
2. 生成 — 停止した状態で `db diff` し、`supabase/migrations/` へ出力する
3. 適用 — 起動して `migration up` でローカルに適用し、型定義を再生成する
4. 反映 — 本番へは `supabase db push`。人間の承認が必要。LLM は実行するな

手順の実体は `/supabase:migrate` に集約する。ここに bash を書くな（二重メンテを避けよ）。

### Limitations

`db diff` は live DB を読まない。`supabase/schemas/` と `supabase/migrations/` を比較するだけである。

以下は `db diff` が拾わないため、migration へ手書きする必要がある。

- DML（insert / update / delete）
- materialized view
- view の ownership / security invoker 設定
- RLS policy の ALTER 文、column privileges
- schema privileges、comment、partition
- domain 文、publication へのテーブル追加
- default privileges 由来の重複 grant

### Rollback

- 開発中: `supabase db reset` で作り直せ
- 本番: `*.schema.sql` を戻して前進 migration を生成せよ。適用済み migration の削除・改変はデータ損失を招く

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

```toml supabase/config.toml
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
- `supabase/seeds/storages/*.storage.seed.sql` — Storage seed files（object insertion only）
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

```.env ~/ghq/**/.env
# Vault Secrets
VAULT_SUPABASE_URL=
VAULT_SERVICE_ROLE_KEY=

# Run the Terminal
#
# Production
# VAULT_SUPABASE_URL=https:*.supabase.co
# VAULT_SERVICE_ROLE_KEY=
```

```.env ~/ghq/**/supabase/functions/.env
# Edge Function Secrets
ENVIRONMENT=development

# Run the Terminal
#
# Production
# supabase secrets set ENVIRONMENT=production --project-ref <project-id>
```

## MCP

- サーバー名は `supabase-development` / `supabase-production` に統一せよ
  - `deny` は tool 名の完全一致で効く。規約を外れると production が無防備になる
- 両方に `read_only=true` を付けよ
  - migration は CLI（`/supabase:migrate`）で行うため、MCP 経由の書き込みは不要

```json .mcp.json
{
  "mcpServers": {
    "supabase-development": {
      "type": "http",
      "url": "http://localhost:54321/mcp?read_only=true"
    },
    "supabase-production": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?project_ref=<project-id>&read_only=true"
    }
  }
}
```

## References

- [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas)
