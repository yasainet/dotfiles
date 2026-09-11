---
name: simplepowers-01-explore
description: Simplepowers Explore
---

# Explore

## Do

- `user` の質問、目的の対象を深く調査せよ
  - 質問: `user` の理解を深め、疑問を解消する
  - 目的: `user` の Goal を達成する Plan の材料を揃える

### Tools

| When                     | Tools                               |
| ------------------------ | ----------------------------------- |
| 内部の探索範囲           | `@Explore`                          |
| 外部の探索範囲           | `@general-purpose`, `deep-research` |
| 最新の情報を引く         | `context7`                          |
| Claude Code の仕様を引く | `claude-code-guide`                 |

## Don't

- LLM の知識や推測に頼らず、最新の情報を調査せよ
- ファイルの編集を禁止する

## Done

`user` が Goal に合意したら `Plan` へ移行せよ。
