---
name: structure
description: Explain project structure patterns (Next.js/Node.js/Deno), tsconfig differences, and ESLint rules
disable-model-invocation: false
---

# Project Structure Guide

## 1. Project Patterns

Four patterns based on runtime combinations:

### Pattern A: Node.js only

```text
project/
├── scripts/
│   └── features/
├── tsconfig.json
└── package.json
```

### Pattern B: Next.js + Node.js

```text
project/
├── src/
│   └── features/
├── scripts/
│   └── features/
├── tsconfig.json
└── package.json
```

### Pattern C: Next.js + Deno

```text
project/
├── src/
│   └── features/
├── supabase/
│   └── functions/
│       └── features/
├── tsconfig.json
└── package.json
```

### Pattern D: Next.js + Node.js + Deno

```text
project/
├── src/
│   └── features/
├── scripts/
│   └── features/
├── supabase/
│   └── functions/
│       └── features/
├── tsconfig.json
└── package.json
```

## 2. tsconfig Differences

### Scripts-only (Pattern A)

- No `paths` aliases
- Use relative paths with `.js` extension
- `module: "nodenext"`, `moduleResolution: "nodenext"`

### Next.js projects (Patterns B, C, D)

- `paths`: `@/*` → `./src/*`
- `moduleResolution: "bundler"`
- `scripts/` can also reference `src/` via `@/` alias (when present in the same project)
- `supabase/functions/` is excluded from `tsconfig.json` — uses Deno's own `deno.json` import map, no `@/` alias
