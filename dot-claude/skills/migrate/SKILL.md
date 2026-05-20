---
name: migrate
description: [Skills] Supabase migration workflow
argument-hint: <migration-name>
disable-model-invocation: true
allowed-tools: Bash(supabase *), Bash(docker compose *), Bash(grep *), Bash(test *)
---

# Supabase Migrate

1. MinIO 利用の判定

```bash
COMPOSE_FILE=""
[ -f docker-compose.yml ] && COMPOSE_FILE=docker-compose.yml
[ -z "$COMPOSE_FILE" ] && [ -f compose.yml ] && COMPOSE_FILE=compose.yml
USE_MINIO=0
[ -n "$COMPOSE_FILE" ] && grep -q -i minio "$COMPOSE_FILE" && USE_MINIO=1
```

2. shadow DB 競合回避のため停止

```bash
[ "$USE_MINIO" = "1" ] && docker compose down
```

3. migration と型定義の生成

```bash
supabase db diff -f $ARGUMENTS
supabase db push --local
supabase gen types typescript --local > src/lib/supabase/type.ts
```

4. `scripts/`, `supabase/functions/` の check

```bash
[ -d scripts/lib/supabase ] \
  && cp src/lib/supabase/type.ts scripts/lib/supabase/type.ts
[ -d supabase/functions/_lib/supabase ] \
  && cp src/lib/supabase/type.ts supabase/functions/_lib/supabase/type.ts
```

5. MinIO 起動

```bash
[ "$USE_MINIO" = "1" ] && docker compose up -d
```
