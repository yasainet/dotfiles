---
paths:
  - "**/*.ts"
  - "**/*.mjs"
---

## Comment

- Write in simple English
- Describe "why" this code exists, not the implementation details

## JSDoc

Write a JSDoc comment for every exported function.
Do not use any JSDoc tags (`@description`, `@param`, `@example`, etc.). Use the comment body directly.

### Single-line (default)

```js
/** <description>. */
```

### Multi-line

When the function has 2 or more independent conditions or behaviors, write a summary followed by a bullet list.

```js
/**
 * <summary>:
 * - <condition or behavior A>
 * - <condition or behavior B>
 * - <condition or behavior C>
 */
```
