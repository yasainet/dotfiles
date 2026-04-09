---
name: migrate
description: Supabase のマイグレーションワークフロー（diff、push、gen types）を実行する
argument-hint: <migration-name>
disable-model-invocation: true
allowed-tools: Bash(supabase *)
---

# Supabase Migrate

確認を取らず、すべてのコマンドを順番に実行する:

1. `supabase db diff -f $ARGUMENTS`
2. `supabase db push --local`
3. `supabase gen types typescript --local > src/lib/supabase/supabase.type.ts`
4. `[ -d scripts/lib/supabase ] && cp src/lib/supabase/supabase.type.ts scripts/lib/supabase/supabase.type.ts`
5. `[ -d supabase/functions/_lib/supabase ] && cp src/lib/supabase/supabase.type.ts supabase/functions/_lib/supabase/supabase.type.ts`
