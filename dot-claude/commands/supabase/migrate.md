---
description: Supabase migration workflow
argument-hint: <migration-name>
allowed-tools: Bash(supabase *), Bash(docker compose *), Bash(grep *), Bash(test *), Bash(cp *), Bash(mkdir *)
---

## Steps

1. 停止（`db diff` は shadow DB を使うため、競合を避ける）

```bash
COMPOSE_FILE=""
[ -f docker-compose.yml ] && COMPOSE_FILE=docker-compose.yml
[ -z "$COMPOSE_FILE" ] && [ -f compose.yml ] && COMPOSE_FILE=compose.yml
if [ -n "$COMPOSE_FILE" ] && grep -q -i minio "$COMPOSE_FILE"; then
  docker compose down
fi
supabase stop
```

2. migration の生成

```bash
supabase db diff -f $ARGUMENTS
```

3. 適用と型定義の生成・配布

```bash
set -e

# 生成済み型定義の実在パスを検出し、無ければ既定値へ fallback する
# --include は zsh に glob されるためクォート必須
TYPES_PATH=$(grep -rl "export type Database" src --include='*.ts' 2>/dev/null | head -1)
[ -n "$TYPES_PATH" ] || TYPES_PATH=src/lib/supabase/types.ts
TYPES_NAME=$(basename "$TYPES_PATH")

supabase start
supabase migration up --local

mkdir -p "$(dirname "$TYPES_PATH")"
supabase gen types typescript --local > "$TYPES_PATH"

if [ -d scripts/lib/supabase ]; then
  cp "$TYPES_PATH" "scripts/lib/supabase/$TYPES_NAME"
fi
if [ -d supabase/functions/_lib/supabase ]; then
  cp "$TYPES_PATH" "supabase/functions/_lib/supabase/$TYPES_NAME"
fi
```

4. 復旧（Step 2, 3 の成否に関わらず実行する。`supabase start` は冪等）

```bash
supabase start
COMPOSE_FILE=""
[ -f docker-compose.yml ] && COMPOSE_FILE=docker-compose.yml
[ -z "$COMPOSE_FILE" ] && [ -f compose.yml ] && COMPOSE_FILE=compose.yml
if [ -n "$COMPOSE_FILE" ] && grep -q -i minio "$COMPOSE_FILE"; then
  docker compose up -d
fi
```
