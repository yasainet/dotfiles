---
paths:
  - "**/services/*.ts"
  - "**/queries/*.ts"
---

# JSDoc Rules

- JSDoc の役割は、LLM がコードから理解ができない `Why` を記載せよ
  - `What`, `How` は、コードが担当している
- JSDoc tags は禁止する
- 1 文 1 行、一文一義を原則とし、1 文は 60 文字以内を推奨する

## Single-line

```ts sample.ts
/** <description> */
```

## Multi-line

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
