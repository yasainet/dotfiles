---
status: draft
date: 2026-03-03
---

# Supabase: seed.sql で auth.users を作成する

## 概要

ローカル開発環境でテストユーザーを用意するために、`supabase/seed.sql` から `auth.users` テーブルへ直接 INSERT する手法。`supabase db reset` のたびにユーザーが再作成されるため、開発・CI の初期化に便利。

公式ドキュメントにはこの手法の体系的な記載がなく、GitHub Discussion で断片的に議論されている。このドキュメントはそれらの知見を整理したもの。

## SQL テンプレート

3 ステップで構成される。

### Step 1: auth.users

```sql
insert into
  auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    recovery_token,
    email_change,
    email_change_token_new,
    email_change_token_current,
    email_change_confirm_status,
    phone_change,
    phone_change_token,
    reauthentication_token,
    is_sso_user,
    is_anonymous
  )
values
  (
    '00000000-0000-0000-0000-000000000000', -- instance_id: 固定値
    '00000000-0000-0000-0000-000000000001', -- id: ユーザー UUID
    'authenticated',                         -- aud
    'authenticated',                         -- role
    'test@mail.com',                         -- email
    crypt('hogehoge!', gen_salt('bf')),        -- encrypted_password
    now(),                                   -- email_confirmed_at
    '{"provider": "email", "providers": ["email"]}',
    '{}',
    now(),                                   -- created_at
    now(),                                   -- updated_at
    '',                                      -- confirmation_token
    '',                                      -- recovery_token
    '',                                      -- email_change
    '',                                      -- email_change_token_new
    '',                                      -- email_change_token_current
    0,                                       -- email_change_confirm_status
    '',                                      -- phone_change
    '',                                      -- phone_change_token
    '',                                      -- reauthentication_token
    false,                                   -- is_sso_user
    false                                    -- is_anonymous
  );
```

### Step 2: auth.identities

```sql
insert into
  auth.identities (
    id,
    user_id,
    provider_id,
    identity_data,
    provider,
    last_sign_in_at,
    created_at,
    updated_at
  )
values
  (
    gen_random_uuid(),                       -- id: ランダム UUID
    '00000000-0000-0000-0000-000000000001', -- user_id: Step 1 の id と一致
    'test@mail.com',                         -- provider_id: email の場合はメールアドレス
    jsonb_build_object(
      'sub', '00000000-0000-0000-0000-000000000001',
      'email', 'test@mail.com'
    ),                                       -- identity_data
    'email',                                 -- provider
    now(),                                   -- last_sign_in_at
    now(),                                   -- created_at
    now()                                    -- updated_at
  );
```

### Step 3: public テーブルの更新（任意）

`auth.users` への INSERT がトリガーで `public.users` などを作成する場合、追加フィールドを更新する。

```sql
update public.users
set
  username = 'test',
  display_name = 'Test User'
where
  id = '00000000-0000-0000-0000-000000000001';
```

## カラム説明

### auth.users

| カラム                   | 値                            | 説明                                                |
| ------------------------ | ----------------------------- | --------------------------------------------------- |
| `instance_id`            | `'00000000-...-000000000000'` | 固定値。マルチテナント用だが現在は未使用            |
| `id`                     | 任意の UUID                   | ユーザーの一意識別子。`public` テーブルの FK になる |
| `aud`                    | `'authenticated'`             | Audience。必ず `'authenticated'`                    |
| `role`                   | `'authenticated'`             | ロール。必ず `'authenticated'`                      |
| `email`                  | メールアドレス                | ログインに使うメールアドレス                        |
| `encrypted_password`     | `crypt(pw, gen_salt('bf'))`   | bcrypt ハッシュ。平文を入れるとログイン不可         |
| `email_confirmed_at`     | `now()`                       | NULL のままだとメール未確認扱いでログイン不可       |
| `raw_app_meta_data`      | JSON                          | `provider` と `providers` を含む必要がある          |
| `raw_user_meta_data`     | JSON                          | ユーザーメタデータ。`{}` で可                       |
| `confirmation_token`     | `''`                          | 空文字を設定。NULL 不可                             |
| `recovery_token`         | `''`                          | 空文字を設定。NULL 不可                             |
| `email_change_*`         | `''` / `0`                    | すべて空文字または 0 を設定                         |
| `phone_change_*`         | `''`                          | 空文字を設定                                        |
| `reauthentication_token` | `''`                          | 空文字を設定                                        |
| `is_sso_user`            | `false`                       | SSO ユーザーかどうか                                |
| `is_anonymous`           | `false`                       | 匿名ユーザーかどうか                                |

### auth.identities

| カラム          | 値                                      | 説明                                     |
| --------------- | --------------------------------------- | ---------------------------------------- |
| `id`            | `gen_random_uuid()`                     | identity の一意識別子                    |
| `user_id`       | `auth.users.id` と同じ UUID             | FK。必ず一致させる                       |
| `provider_id`   | メールアドレス                          | email プロバイダーの場合はメールアドレス |
| `identity_data` | `{"sub": "<uuid>", "email": "<email>"}` | `sub` は `auth.users.id` と一致させる    |
| `provider`      | `'email'`                               | 認証プロバイダー名                       |

## 既知の Pitfalls

### 1. auth.identities の INSERT が必須

`auth.users` だけ INSERT しても、`auth.identities` がなければサインインできない。Supabase の認証フローは `identities` テーブルを参照してプロバイダーの照合を行う。

### 2. トークン系カラムは空文字を設定

`confirmation_token`, `recovery_token`, `email_change_token_*` などは NOT NULL 制約がある。NULL ではなく空文字 `''` を設定する。

### 3. encrypted_password は bcrypt ハッシュが必須

平文パスワードを直接入れるとサインインに失敗する。必ず `crypt('password', gen_salt('bf'))` で bcrypt ハッシュを生成する。

### 4. pgcrypto のスキーマ修飾が必要な場合がある

ローカル環境で `crypt()` や `gen_salt()` が見つからないエラーが出る場合、`extensions.crypt()`, `extensions.gen_salt()` のようにスキーマ修飾が必要。Supabase のバージョンや `search_path` の設定に依存する。

```sql
-- エラーが出る場合
encrypted_password = extensions.crypt('pass1234', extensions.gen_salt('bf'))
```

### 5. email_confirmed_at を NULL にしない

`email_confirmed_at` が NULL のままだと、メール確認が未完了の扱いになりサインインできない。`now()` を設定する。

### 6. raw_app_meta_data の provider 設定

`raw_app_meta_data` に `provider` と `providers` を正しく設定しないと、認証フローで不整合が起きる可能性がある。

```json
{ "provider": "email", "providers": ["email"] }
```

### 7. identity_data の sub フィールド

`identity_data` の `sub` は `auth.users.id` と一致させる必要がある。不一致だと認証時にユーザーの紐づけに失敗する。

## 代替手段

### Admin API

Supabase Admin API を使ってプログラムでユーザーを作成する方法。SQL を書かずに済むが、seed.sql には組み込めない。

```typescript
const { data, error } = await supabase.auth.admin.createUser({
  email: "test@mail.com",
  password: "pass1234",
  email_confirm: true,
});
```

### Hybrid アプローチ

1. Admin API でユーザーを作成
2. `pg_dump` で `auth.users` と `auth.identities` をエクスポート
3. エクスポートした SQL を `seed.sql` に組み込む

パスワードハッシュの互換性問題を回避でき、最も安全な方法。

## 参考リンク

- [Seeding your database | Supabase Docs](https://supabase.com/docs/guides/local-development/seeding-your-database)
- [Users | Supabase Docs](https://supabase.com/docs/guides/auth/users)
- [User Management | Supabase Docs](https://supabase.com/docs/guides/auth/managing-user-data)
- [Seeding `auth.users` - Discussion #35391](https://github.com/orgs/supabase/discussions/35391)
- [Can't seed or signup auth users locally - Discussion #9251](https://github.com/orgs/supabase/discussions/9251)
- [Programmatically create new users - Discussion #5043](https://github.com/orgs/supabase/discussions/5043)
- [Supabase Seed Users Gist](https://gist.github.com/khattaksd/4e8f4c89f4e928a2ecaad56d4a17ecd1)
- [Seeding users in Supabase with a SQL seed script - DEV Community](https://dev.to/paullaros/seeding-users-in-supabase-with-a-sql-seed-script-41mh)
