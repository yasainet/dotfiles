Run:

```sh
supabase db diff -f <UPDATE_COMMENT>
supabase db reset --local
supabase gen types typescript --local > src/lib/supabase/supabase.type.ts
```
