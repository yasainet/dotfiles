---
paths:
  - "**/docs/superpowers/specs/**/*.md"
  - "**/docs/superpowers/plans/**/*.md"
---

# Superpowers Scaffold

`docs/superpowers/{specs,plans}/` は superpowers skill が生成する scaffold 層。
書き方は superpowers skill (writing-plans / brainstorming) が持つ。
ここに書くのはプロジェクト固有の位置づけと接続規約だけ。

## 位置づけ

- scaffold は実装で陳腐化してよい足場である
- living (`docs/ROADMAP.md` / `docs/DECISIONS.md`) と frozen (`docs/research/`) と混同するな
- 内容は使い捨てなので「コードから導出できる情報」を書いてよい例外領域である

## 接続

- spec で確定した不可逆 / 包括判断は `docs/DECISIONS.md` に 1 行流せ
- spec は research と重複させるな (research は legacy の事実、spec はこれから作る設計)
- 1 spec = 1 サイクル = 1 vertical slice を原則とせよ

> [!NOTE]
> CLAUDE.md / path-rule が WHAT / WHY を、superpowers が HOW を、と層を分けている。
> spec / plan を「正典」扱いせず、確定判断は DECISIONS.md に上げよ。
> 上げ漏れは spec の使い回しを誘発し、正典が割れる。
