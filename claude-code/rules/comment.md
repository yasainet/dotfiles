---
paths:
  - "**/*.ts"
  - "**/*.mjs"
---

# Comment Rules

## Comment, JSDoc

- Write in simple English
- Describe "why" this code exists, not the implementation details
- Do not use any JSDoc tags (`@description`, `@param`, `@example`, etc.). Use the comment body directly.

> [!NOTE]
> Humans read only JSDoc, not the code. Claude Code read JSDoc for intent and code for implementation truth.

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
