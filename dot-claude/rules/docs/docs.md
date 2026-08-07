---
paths:
  - "**/docs/*.md"
  - "**/docs/**/*.md"
  - "**/notes/*.md"
  - "**/notes/**/*.md"
  - "!**/.claude/**"
  - "!**/dot-claude/**"
---

# Docs Rules

`docs/` と `notes/` の構造を規定する。

## 階層

第一階層は Diátaxis の 4 分類とする。domain は第二階層に置く。

|      | 習得 (at study) | 応用 (at work) |
| ---- | --------------- | -------------- |
| 行動 | tutorials       | how-to         |
| 認識 | explanation     | reference      |

```
docs/
  INDEX.md          # 索引
  tutorials/        # 学ぶための手順
  how-to/           # 目的を達成するための手順
  reference/        # 引くための事実
  explanation/      # 現在の設計がなぜそうなっているかの説明
```

- 1 file に 2 種類を混ぜるな。手順と参照を同じ file に書くな
- 迷ったら `how-to/` か `reference/` に置け。後から移せばよい
- domain 名は DB table 名や component 名と揃えよ

`explanation/` には現在の設計だけを書け。

- 変更の経緯を書くな。A を B に変えた理由は commit body にある
- 却下した案を書くな。同じく commit body の担当である

## 命名

- kebab-case で書け
- ALL_CAPS は `README.md`, CLAUDE.md` のみ許す
- 大文字を含む固有名詞も小文字にせよ
  - sample: `Lora` -> `lora`, `ComfyUI` -> `comfyui`
