---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.mjs"
---

# Comment Rules

## JSDoc

- JSDoc tags は禁止する
- JSDoc の役割は、claude code がコードから理解ができない `Why` を記載せよ
  - `What`, `How` は、コードが担当している
- 80 桁以内で簡素に記載せよ

### Single-line

```ts sample.ts
/** <description> */
```

### Multi-line

- 関数に独立した条件や挙動が 2 つ以上ある場合は、Summary を書いた上で Lists を記載せよ
- Lists には、独立した条件、挙動を記載せよ

```ts sample.ts
/**
 * <summary>:
 *
 * - <description>
 * - <description>
 * - <description>
 */
```
