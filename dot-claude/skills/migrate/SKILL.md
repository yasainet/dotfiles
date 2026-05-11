---
name: migrate
description: Supabase のマイグレーションワークフロー（diff、push、gen types）を実行する
argument-hint: <migration-name>
disable-model-invocation: true
allowed-tools: Bash(supabase *), Bash(docker compose *), Bash(grep *), Bash(test *)
---

# Supabase Migrate

```bash
# MinIO 利用プロジェクト判定（compose ファイルに minio 記述があるか）
COMPOSE_FILE=""
[ -f docker-compose.yml ] && COMPOSE_FILE=docker-compose.yml
[ -z "$COMPOSE_FILE" ] && [ -f compose.yml ] && COMPOSE_FILE=compose.yml
USE_MINIO=0
[ -n "$COMPOSE_FILE" ] && grep -q -i minio "$COMPOSE_FILE" && USE_MINIO=1

# shadow DB 競合回避のため停止
[ "$USE_MINIO" = "1" ] && docker compose down

supabase db diff -f $ARGUMENTS
supabase db push --local
supabase gen types typescript --local > src/lib/supabase/type.ts
[ -d scripts/lib/supabase ] && cp src/lib/supabase/type.ts scripts/lib/supabase/type.ts
[ -d supabase/functions/_lib/supabase ] && cp src/lib/supabase/type.ts supabase/functions/_lib/supabase/type.ts

# dev 環境を復旧
[ "$USE_MINIO" = "1" ] && docker compose up -d
```
