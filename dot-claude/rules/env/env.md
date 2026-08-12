---
paths:
  - "**/.env"
  - "**/.env.*"
---

# Env Rules

> [!NOTE]
> this document is WIP.

`.env`, `.env.*` の基本ルールを記述する。

## Next.js

```env ~/ghq/**/root/.env.example
# Environment
APP_ENV=development
APP_URL=http://127.0.0.1:3000

# Supabase
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Resend
RESEND_API_KEY=

# Google Analytics
GA_ID=
```

```env ~/ghq/**/root/.env.local

```

```env ~/ghq/**/root/.env.production

```

## Docker

```env ~/ghq/**/docker/.env.example

```

```env ~/ghq/**/docker/.env.local

```

```env ~/ghq/**/docker/.env.production

```
