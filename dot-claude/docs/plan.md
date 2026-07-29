# Plan

plan mode が書き出す `.claude/plans/*.md` のルールを記述する

## 位置づけ

- plan は承認票である。人間の承認のために存在する
- 承認が終われば役目を終える。成果物ではない
- 人間が読むのは Summary だけ。それ以降は LLM 向け
- why は commit message の body に書け。plan file に決定を蓄積するな
- `user` が行頭で `;go` と書くまで plan を提示するな。hook が `ExitPlanMode` を止める

## Format

既定の挙動との差分だけを指定する。Summary 以降のセクション構成は既定のままでよい

```md
# <タイトル>

<yyyy-mm-dd> 時点の予定

## Summary

- Goal: 依頼をどう解釈したか
- Scope: 触るファイル・範囲
- Decisions: 依頼に無くこちらで判断した点。なければ「なし」
```

## Rules

- Summary は 5 行以内に収めよ。ここだけで承認できる形にせよ
- `Decisions` は網羅するな。書かないと `user` が驚くことだけ書け
- 却下した案を書くな
- 手順の逐次記述とコード断片を書くな。軌道修正を縛り、実装後に嘘になる
- 簡潔さと詳細さで迷ったら簡潔にせよ
