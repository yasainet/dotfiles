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

## 恒久文書だけを置く

close できるものを `docs/` に置くな。issue か PR に書け

- todo, plan, spec, 調査結果, review の指摘が該当する
- 判断基準は一つ。close の概念があるなら GitHub 側、無いなら `docs/`
- ドキュメントは現在の姿だけを語る。使い捨て文書は書いた瞬間から腐る
- 完了しても消し忘れる。issue なら close で状態が残る
- 「今どうなっているか」を書き、「これからどうするか」は書くな
- コード内の `TODO` コメントだけは例外とする
- file 名に日付や連番を付けるな。時系列を持つなら、それは使い捨て文書である

使い捨て文書は `.claude/plans/` にのみ置け。git 管理はするな

## 階層

第一階層は Diátaxis の 4 分類とする。domain は第二階層に置く。

|      | 習得 (at study) | 応用 (at work) |
| ---- | --------------- | -------------- |
| 行動 | tutorials       | how-to         |
| 認識 | explanation     | reference      |

```
docs/
  README.md         # 索引
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

## 索引

- `docs/README.md` を 1 つだけ置け
- 索引を他に作るな。複数あると必ず片方が腐る
- 索引には file への link と 1 行の説明だけを書け。内容を写すな

## 命名

- kebab-case で書け
- ALL_CAPS は `README.md`, `AGENTS.md`, `CLAUDE.md` のみ許す
- 大文字を含む固有名詞も小文字にせよ (`LoRA/` ではなく `lora/`)
