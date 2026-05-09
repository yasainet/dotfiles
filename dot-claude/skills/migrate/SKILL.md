---
name: migrate
description: Supabase のマイグレーションワークフロー（diff、push、gen types）を実行する
argument-hint: <migration-name>
disable-model-invocation: true
allowed-tools: Bash(supabase *)
---

# Supabase Migrate

```bash
supabase db diff -f $ARGUMENTS
supabase db push --local
supabase gen types typescript --local > src/lib/supabase/type.ts
[ -d scripts/lib/supabase ] && cp src/lib/supabase/type.ts scripts/lib/supabase/type.ts
[ -d supabase/functions/_lib/supabase ] && cp src/lib/supabase/type.ts supabase/functions/_lib/supabase/type.ts
```
