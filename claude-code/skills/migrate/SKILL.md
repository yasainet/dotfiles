---
name: supabase-migrate
description: Run the Supabase migration workflow (diff, push, gen types)
argument-hint: <migration-name>
disable-model-invocation: true
allowed-tools: Bash(supabase *)
---

# Supabase Migrate

## Instructions

Run all commands sequentially without confirmation:

1. `supabase db diff -f $ARGUMENTS`
2. `supabase db push --local`
3. `supabase gen types typescript --local > src/lib/supabase/supabase.type.ts`
