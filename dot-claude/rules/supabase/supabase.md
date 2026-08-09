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

置き場所は「誰が読むか」で決めよ。

| 読む主体                       | 置き場所                                           | 参照方法                  |
| ------------------------------ | -------------------------------------------------- | ------------------------- |
| config.toml（auth、smtp 等）   | `supabase/.env`                                    | `env(VAR_NAME)`           |
| Edge Functions                 | `supabase/functions/.env` / `supabase secrets set` | `Deno.env.get()`          |
| SQL（pg_cron、トリガー、関数） | Vault                                              | `vault.decrypted_secrets` |
| DB の外の process（worker 等） | その process 自身の env file                       | `process.env`             |

### config.toml `env()`

- `supabase/.env` と `supabase/.env.sample` の 2 枚にせよ。ここだけ Next.js 側の命名から外す
  - `.env` は CLI が name を決めている。`.env.production` は既定では読まれない
  - `SUPABASE_ENV=production` を付ければ読めるが、付け忘れると空の値が push される
- `supabase/` に置け。ルートは app の env file が占めるため混ぜるな
  - CLI は `supabase/` から repo root へ上がりながら読む（`pkg/config/config.go` の `loadNestedEnv`）
  - 公式 docs はルートの `.env` と書くが、`supabase/` 階層の方が先に読まれる
- 未解決の `env()` は `WARN: environment variable is unset:` を出すだけで push は成功する
  - exit code も変わらないため CI では気付けない

dev と prod で値が割れる key は、`.env` に prod をコメントで併記し、push の前に入れ替えよ。

```env supabase/.env
VAULT_SUPABASE_URL=http://127.0.0.1:54321

# Run the Terminal
#
# Production
# VAULT_SUPABASE_URL=https://<project-id>.supabase.co
```

`.env.local` は「local stack にしか効かない key」専用である。本番へ流れる key を置くな。
`.env.production` より先に読まれて先勝ちし、`SUPABASE_ENV=production` を付けても順序は変わらない。

### Vault

- 値は `env()` と同じ `supabase/.env` から読む。専用の file を作るな
- `config.toml` の `[db.vault]` に書けば CLI が登録する
  - local は `migration up` / `db reset`、本番は `db push` が適用する（`UpsertVaultSecrets`）
  - dev と prod で値が割れるため、`db push` の前に `.env` を prod の値へ入れ替えよ
  - この経路は docs に無い。案内されているのは Dashboard と `vault.create_secret()` だけである
- 読めるのは SQL だけ。DB の外で動く process から使うな
  - 到達するには URL と service_role key が先に要り、env file は結局消えない
  - `vault` schema は PostgREST に公開されていない
- `vault.decrypted_secrets` は権限を絞れ。view を読めれば平文が読める

### Edge Functions

- `supabase/functions/.env` と `supabase/functions/.env.sample` の 2 枚にせよ
  - `supabase/.env` と同じ構成である。key の一覧が追跡対象に残る
  - `.env` は gitignore 対象で、clone した直後は存在しない
- development は `supabase/functions/.env`。`supabase start` が自動で読む
- 別 file を使うなら `supabase functions serve --env-file <path>`
  - `--env-file` を受けるのはこの系統だけである。`config push` には無い
- production は `supabase secrets set --env-file <path>`。deploy し直す必要は無い

### CLI 自身

docs にあるもの。

- `SUPABASE_ACCESS_TOKEN` — CI で login を省く
- `SUPABASE_DB_PASSWORD` — prompt を避ける
- `SUPABASE_WORKDIR` / `SUPABASE_SERVICES_HOSTNAME`

docs に無く、実装にだけあるもの。使うなら docs 外だと承知の上で使え。

- `SUPABASE_ENV` — 読む env file を選ぶ
- `SUPABASE_<PATH>_<KEY>` — config.toml の任意の項目を上書きする
  - viper の `AutomaticEnv`。key の `.` を `_` に置換した名前になる
  - 例: `SUPABASE_AUTH_SITE_URL`、`SUPABASE_REMOTES_PRODUCTION_PROJECT_ID`

### gitignore

- `.env*` を除外し、`!.env.sample` だけ戻せ
- `supabase/.gitignore` が除外するのは `.env.local` と `.env.*.local` である
  - `.env` と `.env.production` はルートの `.env*` で守る

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
supabase/
├── .env.sample        # config.toml env() が読む key の一覧（追跡対象）
├── .env               # その値（gitignore 対象）
├── config.toml        # Supabase 設定
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
    ├── .env.sample    # Edge Functions が読む key の一覧（追跡対象）
    └── .env           # その値（gitignore 対象）
```

## env

```env ~/ghq/**/supabase/.env.sample
# Resend
RESEND_API_KEY=

# Vault Secrets
VAULT_SUPABASE_URL=http://127.0.0.1:54321
VAULT_SERVICE_ROLE_KEY=

# Run the Terminal
#
# Production
# VAULT_SUPABASE_URL=https://<project-id>.supabase.co
# VAULT_SERVICE_ROLE_KEY=
```

```env ~/ghq/**/supabase/.env

```

```env ~/ghq/**/supabase/functions/.env.sample
# Edge Function Secrets
ENVIRONMENT=development

# Run the Terminal
#
# Production
# supabase secrets set ENVIRONMENT=production --project-ref <project-id>
```

```env ~/ghq/**/supabase/functions/.env

```

## References

- [Declarative Database Schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas)
