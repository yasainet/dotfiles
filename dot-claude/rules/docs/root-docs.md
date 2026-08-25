---
paths:
  - "**/README.md"
  - "**/CLAUDE.md"
  - "!**/.claude/**"
  - "!**/dot-claude/**"
  - "!**/docs/**"
  - "!**/notes/**"
---

# Root Docs Rules

repo root に置く README.md, CLAUDE.md のルール集。

## Rules

- README.md は 人間向けに記述せよ
- CLAUDE.md は agent 向けに記述せよ
- 各ファイル 200 行以内に収めよ
  - 200 行を超える場合は、`docs/**/*.md` を利用せよ

## README.md sample format

````markdown
# Service name

tagline

## Summary

- list
- list
- list

## Setup

```sh
# setup commands
npm ci
supabase start
docker compose up -d
```

## Commands

```sh
# usage commands
npm run dev
npm run build
```

## Verify

```sh
npm run lint
npm run type-check
npm run knip

npm run test
npm run test:e2e

npm run build
```

## Environments

Vercel:

|                 | Production          | Preview                                 | Development           |
| --------------- | ------------------- | --------------------------------------- | --------------------- |
| Branch Tracking | `main`              | All unassigned git branches             | Accessible via CLI    |
| Domains         | https://example.com | https://example-git-<branch>.vercel.app | http://127.0.0.1:3000 |
| Next.js         | Vercel              | Vercel                                  | Mac                   |
| DB              | Supabase Cloud      | Supabase Cloud                          | Supabase CLI          |
| Storage         | Supabase Storage    | Supabase Storage                        | Supabase Storage      |
| Auth            | Supabase Auth       | Supabase Auth                           | Supabase Auth         |
| Mail            | Resend              | Resend                                  | Supabase (Mailpit)    |

VPS:

|                 | Production          | Staging                     | Development           |
| --------------- | ------------------- | --------------------------- | --------------------- |
| Branch Tracking | `main`              | `staging`                   | Accessible via CLI    |
| Domains         | https://example.com | https://staging.example.com | http://127.0.0.1:3000 |
| Next.js         | VPS (Docker)        | VPS (Docker)                | Mac                   |
| DB              | Supabase (Docker)   | Supabase (Docker)           | Supabase CLI          |
| Storage         | Garage (Docker)     | Garage (Docker)             | Garage (Docker)       |
| Auth            | Supabase Auth       | Supabase Auth               | Supabase Auth         |
| Mail            | Resend              | Resend                      | Supabase (Mailpit)    |
````

## CLAUDE.md sample format

```markdown
# CLAUDE.md

tagline

## Summary

- list

## Rules

- list
```
