---
paths:
  - "**/supabase/**"
---

# Supabase Rules

- Supabase / Supabase CLI についてのルール。

## Directory Structure

```text
  supabase/
  ├── .env.sample        # config.toml env()
  ├── .env               # config.toml env()
  ├── config.toml
  ├── migrations/
  ├── schemas/           # Declarative database schemas
  │   ├── .pgdelta-export.json
  │   ├── _cluster/
  │   │   ├── extensions/        # <extension>.sql
  │   │   └── roles.sql
  │   ├── _custom/
  │   └── <schema>/              #  public/
  │       ├── schema.sql
  │       ├── default_privileges.sql
  │       └── <NN>_<name>.sql    # ex: 01_users.sql
  ├── seeds/
  │   ├── *.seed.sql             # ex: 01_users.seed.sql
  │   ├── storages/              # ex: 01.storage.seed.sql
  │   │   └── <bucket_name>/
  │   └── scripts/
  │       ├── *.local.sql
  │       └── *.production.sql   # Run manually
  ├── snippets/
  ├── templates/
  └── functions/         # Supabase Edge Functions
      ├── .env.sample
      └── .env
```

## Declarative database schemas / 宣言的データベーススキーマ

Declarative database schema を利用せよ。

1. 宣言: `supabase/schemas/<schema>/<NN>_<name>.sql` に宣言せよ
   - 拡張は `supabase/schemas/_cluster/extensions/<extension>.sql`
2. 生成: `supabase db schema declarative sync --name <name> --apply` で生成せよ
3. 型生成: `supabase gen types typescript --local > src/lib/supabase/types.ts` を生成せよ
4. 反映: `supabase db push` で反映せよ
   - develop: `supabase db push --local`
   - prod: `supabase db push --linked`
5. 更新: `supabase/schemas/.pgdelta-export.json` を更新せよ

## Schema Template

`supabase/schemas/<schema>/<NN>_<name>.sql` は、以下の雛形に従え。

```sql 00_common.sql
-- Function
create function public.update_updated_at_column()
returns trigger
language plpgsql
set search_path to ''
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;
```

```sql 01_users.sql
-- Types
create type public.user_gender as enum('male', 'female');

-- Table
create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null unique,
  avatar_path text,
  gender public.user_gender,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  deleted_at timestamp with time zone
);

-- Index
create index users_created_at_idx on public.users (created_at desc);

-- Function
create function public.soft_delete_user()
returns void
language plpgsql
set search_path to ''
as $$
begin
  update public.users
  set deleted_at = now()
  where id = (select auth.uid());
end;
$$;

-- Trigger
create trigger users_update_updated_at before update on public.users for each row execute function public.update_updated_at_column();

-- RLS
alter table public.users enable row level security;

-- RLS for anon
create policy "Users are viewable by everyone" on public.users
  for select to anon
  using (deleted_at is null);

create policy "Anon users cannot insert users" on public.users
  for insert to anon
  with check (false);

create policy "Anon users cannot update users" on public.users
  for update to anon
  using (false);

create policy "Anon users cannot delete users" on public.users
  for delete to anon
  using (false);

-- RLS for authenticated
create policy "Users are viewable by authenticated users" on public.users
  for select to authenticated
  using (deleted_at is null);

create policy "Users can insert their own profile" on public.users
  for insert to authenticated
  with check ((select auth.uid()) = id);

create policy "Users can update their own profile" on public.users
  for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create policy "Authenticated users cannot delete users" on public.users
  for delete to authenticated
  using (false);

-- GRANT
grant select on table public.users to anon;
grant select, insert, update on table public.users to authenticated;
grant all on table public.users to service_role;
grant execute on function public.soft_delete_user() to authenticated;
```

## View Template

`supabase/schemas/<schema>/<NN>_<name>.sql` (view) は、以下の雛形に従え。

```sql <NN>_<name>.sql
create view public.<name>
with (security_invoker = true) as
select ...;

grant SELECT on table public.<name> to anon, authenticated;
grant all on table public.<name> to service_role;
```

- app が読む view を追加したら `src/lib/supabase/database.ts` の override に追記せよ
- app は `Database` を `types.ts` からではなく `database.ts` から import せよ
- type-fest の MergeDeep で上書きせよ

```ts src/lib/supabase/database.ts
import type { MergeDeep } from "type-fest";

import type { Database as DatabaseGenerated } from "./types";

export type Database = MergeDeep<
  DatabaseGenerated,
  {
    public: {
      Views: {
        <view_name>: {
          Row: {
            // view の実際の型
          };
        };
      };
    };
  }
>;
```

## References

- [Declarative database schemas](https://supabase.com/docs/guides/local-development/declarative-database-schemas)
- [Securing your Data API](https://supabase.com/docs/guides/api/securing-your-api)
- [Database: Create RLS policies](https://github.com/supabase/supabase/blob/master/examples/prompts/database-rls-policies.md)
- [Generating TypeScript Types](https://supabase.com/docs/guides/api/rest/generating-types)
