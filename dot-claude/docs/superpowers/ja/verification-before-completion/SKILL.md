---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

# Verification Before Completion

## Overview

核となる原則: 主張の前に証拠を。常にだ。

この規則の字面を破ることは、この規則の精神を破ることだ。

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

この message の中で検証の command を実行していないなら、通ったとは言えない。

## The Gate Function

```
状態を主張する前、満足を表す前に:

1. 特定: どの command がこの主張を証明するか
2. 実行: その command を丸ごと実行する (新たに、完全に)
3. 読解: 出力を全て読み、終了 code を確かめ、失敗の数を数える
4. 検証: 出力は主張を裏付けているか
   - 裏付けていないなら: 実際の状態を証拠と共に述べる
   - 裏付けているなら: 主張を証拠と共に述べる
5. その後で初めて: 主張する

一つでも飛ばせば、それは検証ではなく嘘だ
```

## Common Failures

| 主張 | 必要なもの | 不十分なもの |
|-------|----------|----------------|
| test が通る | test command の出力: 失敗 0 | 前回の実行、「通るはず」 |
| linter が綺麗 | linter の出力: error 0 | 部分的な確認、そこからの推測 |
| build が通る | build command: 終了 0 | linter が通った、log が良さそう |
| bug が直った | 元の症状の test: 通る | code を変えた、直ったつもり |
| 回帰 test が働く | red-green の周期を確認済み | test が一度通った |
| agent が完了した | VCS の diff に変更が見える | agent が「成功」と報告した |
| 要件を満たした | 一行ずつの checklist | test が通っている |

## Red Flags - STOP

- 「はず」「たぶん」「〜のように見える」を使っている
- 検証の前に満足を表している (「よし」「完璧」「完了」など)
- 検証せずに commit/push/PR しようとしている
- agent の成功報告を信じている
- 部分的な検証に頼っている
- 「今回だけ」と考えている
- 疲れていて終わらせたい
- 検証を実行せずに成功を匂わせる、あらゆる言い回し

## Rationalization Prevention

| 言い訳 | 実際 |
|--------|---------|
| 「もう動くはず」 | 検証を実行せよ |
| 「自信がある」 | 自信は証拠ではない |
| 「今回だけ」 | 例外は無い |
| 「linter は通った」 | linter は compiler ではない |
| 「agent が成功と言った」 | 自分で確かめよ |
| 「疲れている」 | 疲労は言い訳にならない |
| 「部分的な確認で足りる」 | 部分は何も証明しない |
| 「言い方が違うから規則の外だ」 | 字面より精神 |

## Key Patterns

test:
```
✅ [test command を実行] [結果: 34/34 通過] 「全ての test が通る」
❌ 「もう通るはず」「正しそうだ」
```

回帰 test (TDD の Red-Green):
```
✅ 書く → 実行 (通る) → 修正を戻す → 実行 (必ず落ちる) → 修正を復元 → 実行 (通る)
❌ 「回帰 test を書きました」(red-green の確認なし)
```

build:
```
✅ [build を実行] [結果: 終了 0] 「build が通る」
❌ 「linter が通った」(linter は compile を確かめない)
```

要件:
```
✅ 計画を読み直す → checklist を作る → 一つずつ確かめる → 抜けか完了を報告する
❌ 「test が通ったので phase は完了」
```

agent への委任:
```
✅ agent が成功を報告 → VCS の diff を確認 → 変更を検証 → 実際の状態を報告
❌ agent の報告を信じる
```

## When To Apply

必ず次の前に:
- 成功や完了を主張する、あらゆる言い方
- 満足を表す、あらゆる表現
- 作業の状態についての、あらゆる肯定的な発言
- commit、PR の作成、task の完了
- 次の task へ移ること
- agent への委任

この規則が及ぶ範囲:
- そのままの文言
- 言い換えと類語
- 成功の含み
- 完了や正しさを匂わせる、あらゆる伝達
