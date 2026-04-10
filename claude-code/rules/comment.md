---
paths:
  - "**/*.ts"
  - "**/*.mjs"
---

# Comment Rules

## Comment, JSDoc

- 実装の詳細ではなく、「なぜ（why）」このコードが存在するのかを記述する
- JSDoc タグ（`@description`、`@param`、`@example` など）は使わない。コメント本文を直接書く

> [!NOTE]
> 人間は JSDoc しか読まず、コードは読まない。Claude Code は意図を JSDoc から、実装の真実をコードから読み取る。

### Single-line (default)

```js
/** <description>. */
```

### Multi-line

関数に独立した条件や挙動が 2 つ以上ある場合は、サマリーを書いた上で箇条書きを続ける。すべての条件を list 形式で列挙すること。

```js
/**
 * <summary>:
 *
 * - <description>
 * - <description>
 * - <description>
 */
```
