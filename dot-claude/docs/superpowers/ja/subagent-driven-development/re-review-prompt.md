# Scoped Re-Review Prompt Template

fix round の後に再 review を起動するときに、この template を使え。再 reviewer は findings が片付いたことを確かめ、修正 diff に新しい破損が無いか見る。これは新規の review ではない。完全な review は既に済んでいる。

目的: 前の review の findings が一つずつ片付いたこと、そして修正自体が何も壊していないことを確かめる。

```
Subagent (general-purpose):
  description: "Re-review Task N fix round R"
  model: [MODEL — 必須: SKILL.md の Model Selection に従って選べ。省くと
         session の最も高価な model を静かに受け継ぐ]
  prompt: |
    あなたは、一つの task の fix round を再 review する。前の review が findings を
    出し、implementer がそれを直そうとした。あなたの仕事は、findings ごとに判定を
    下し、修正 diff を見ることだ。それ以外はしない。

    ## その task

    task の brief を読め: [BRIEF_FILE]

    ## 確かめる findings

    [FINDINGS]

    ## 修正

    implementer の報告を読め (修正の報告は末尾に追記されている):
    [REPORT_FILE]

    fix base: [FIX_BASE_SHA] (前の review が見た head)
    head: [HEAD_SHA]
    diff file: [DIFF_FILE]

    diff file を一度読め。修正の commit、統計の要約、周囲の文脈を含む修正 diff が
    入っている。git command を実行し直すな。diff file が無いなら、自分で diff を
    取れ: `git diff --stat [FIX_BASE_SHA]..[HEAD_SHA]` と
    `git diff [FIX_BASE_SHA]..[HEAD_SHA]`。

    この checkout に対する review は read-only だ。working tree、index、HEAD、
    branch の状態を一切変えるな。

    ## 範囲

    あなたの範囲は findings の一覧と修正 diff だ。findings は全て判定せよ。
    修正自体が持ち込んだ新しい問題を、修正 diff の中で探せ。修正が触っていない
    code を再 review するな。修正 diff の完全に外側で問題に気付いたら、
    Out-of-Scope Observations に書け。それはこの task を止めず、loop も延ばさない。
    branch 全体の広い review は、全 task の完了後に行う。

    ## test

    implementer は、変えた code を覆う test を実行し直し、その結果を報告 file に
    追記している。報告は未確認の主張として扱え。修正の報告が、覆う test を名指しし、
    その出力を示していることを確かめ、diff と突き合わせよ。相手の報告を確かめるために
    test 一式を実行し直すな。code を読んで、既存の実行では答えの出ない具体的な疑いが
    生じたときだけ test を実行せよ。そのときも的を絞った test にせよ。package 全体の
    test 一式は実行するな。

    ## 出力形式

    あなたの最後の message がそのまま報告だ。最初の findings の判定から直接始めよ。
    全ての行は、判定か、file:line 付きの findings か、あなたが行った確認だ。
    前置きも、過程の語りも書くな。

    ### Finding Verdicts

    「確かめる findings」の各項目について、順に:
    - [finding の一行] — ADDRESSED | NOT ADDRESSED。file:line の証拠を添える。
      「試みた」は片付いたことにならない。その欠陥が存在しなくなっている必要がある。

    ### New Breakage in the Fix Diff

    修正自体が壊した、あるいは持ち込んだもの。深刻さ (Critical/Important/Minor) と
    file:line を添える。何も無ければ「None」。

    ### Out-of-Scope Observations

    修正 diff の完全に外側で気付いた問題。進行は止めない。controller が最後の review の
    ためにこれを台帳へ記録する。無ければ「None」。

    ### Verdict

    fix round: [全ての findings が片付き、新しい Critical/Important の破損は無い |
    findings が残っている] — 残っているものを挙げよ。
```

穴:
- `[MODEL]` — 必須: SKILL.md の Model Selection に従った reviewer の model。小さな修正 diff への範囲を絞った再 review は、安価から中位の階層でよい
- `[BRIEF_FILE]` — task の brief file (implementer が作業に使ったものと同じ file)
- `[FINDINGS]` — 前の review の Critical/Important の findings と仕様の穴。そのまま写し、一項目一行で
- `[REPORT_FILE]` — implementer の報告 file (修正の報告が追記されている)
- `[FIX_BASE_SHA]` — 前の review が見た head
- `[HEAD_SHA]` — 今の commit
- `[DIFF_FILE]` — `scripts/review-package PLAN_FILE FIX_BASE HEAD` が出力した path

再 reviewer が返すもの: findings ごとの判定 (ADDRESSED / NOT ADDRESSED)、修正 diff の中の新しい破損、範囲外の所見、round の判定。
