# Plan Document Reviewer Prompt Template

計画文書の reviewer subagent を起動するときに、この template を使え。

目的: 計画が揃っていて、仕様と合っていて、task の分割が適切か確かめる。

起動する時点: 計画を書き終えた後。

```
Subagent (general-purpose):
  description: "Review plan document"
  prompt: |
    あなたは計画文書の reviewer だ。この計画が揃っていて、実装へ進める状態か確かめよ。

    review 対象の計画: [PLAN_FILE_PATH]
    参照する仕様: [SPEC_FILE_PATH]

    ## 確認すること

    | 観点 | 見るもの |
    |----------|------------------|
    | 完全性 | TODO、穴、書きかけの task、抜けた step |
    | 仕様との整合 | 計画が仕様の要件を覆っているか。大きな範囲の膨張が無いか |
    | task の分割 | task の境界が明確か。step が実行可能か |
    | 作れるか | 技術者がこの計画に従って、詰まらずに進めるか |

    ## 判断の目安

    実装の段階で実際に問題を起こすものだけを挙げよ。
    実装者が誤ったものを作る、詰まる。これらは問題だ。
    細かな言い回し、書き方の好み、「あると良い」程度の提案は問題ではない。

    重大な穴が無い限り承認せよ。仕様の要件の欠落、矛盾する step、
    埋まっていない穴、実行できないほど曖昧な task が重大な穴だ。

    ## 出力形式

    ## Plan Review

    Status: Approved | Issues Found

    Issues (あれば):
    - [Task X, Step Y]: [具体的な問題] - [実装にとってなぜ重要か]

    Recommendations (助言であり、承認を妨げない):
    - [改善の提案]
```

reviewer が返すもの: Status、Issues (あれば)、Recommendations
