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

Deployments:

| env        | branch | url                                     |
| ---------- | ------ | --------------------------------------- |
| production | `main` | https://example.com                     |
| preview    | PR     | https://example-git-<branch>.vercel.app |
| develop    | local  | http://127.0.0.1:3000                   |

Stacks:

| layer   | production       | development        |
| ------- | ---------------- | ------------------ |
| Next.js | Vercel           | Mac                |
| DB      | Supabase Cloud   | Supabase CLI       |
| Storage | Supabase Storage | Supabase Storage   |
| Auth    | Supabase Auth    | Supabase Auth      |
| Mail    | Resend           | Supabase (Mailpit) |
````

## CLAUDE.md sample format

````markdown
# CLAUDE.md

tagline

## Summary

```sh
# some commands
```
````
