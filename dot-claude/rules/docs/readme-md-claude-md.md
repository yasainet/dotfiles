---
paths:
  - "**/README.md"
  - "**/CLAUDE.md"
---

# README.md, CLAUDE.md Rules

README.md, CLAUDE.md のルール集。

## Rules

- README.md は、人間向けに記述せよ
- CLAUDE.md は、LLM 向けに記述せよ
- 最大 200 行以内で記述すること
  - 200 行を超える場合は、`docs/**/*.md` を利用せよ

## CLAUDE.md sample format / wip

```markdown
# CLAUDE.md

tagline
```

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
```

## Usage

```sh
# usage commands
```

## Environments

Deployments:

| env        | branch | url                                     |
| ---------- | ------ | --------------------------------------- |
| production | `main` | https://example.com                     |
| preview    | PR     | https://example-git-<branch>.vercel.app |
| develop    | local  | http://127.0.0.1:3000                   |

Stakcs:

| env         | Next.js | DB             | Storage |
| ----------- | ------- | -------------- | ------- |
| production  | Vercel  | Supabase Cloud | R2      |
| development | Mac     | Supabase CLI   | MinIO   |
````
