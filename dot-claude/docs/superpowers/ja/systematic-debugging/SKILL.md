---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

核となる原則: 修正を試みる前に、必ず根本原因を突き止めよ。症状への対処は失敗だ。

この手順の字面を破ることは、debug の精神を破ることだ。

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

Phase 1 を終えていないなら、修正を提案できない。

## When to Use

あらゆる技術的な問題に使え。
- test の失敗
- production の bug
- 想定外の振る舞い
- 性能の問題
- build の失敗
- 統合の問題

特に次のときに使え:
- 時間に追われているとき (緊急時ほど当て推量に誘われる)
- 「ちょっと直すだけ」が明白に思えるとき
- 既に複数の修正を試したとき
- 前の修正が効かなかったとき
- 問題を完全には理解していないとき

次を理由に飛ばすな:
- 問題が単純に見える (単純な bug にも根本原因がある)
- 急いでいる (急げば必ずやり直しになる)
- 上司が今すぐ直せと言う (もがくより体系的な方が速い)

## The Four Phases

各 phase を終えてから、次へ進め。

### Phase 1: Root Cause Investigation

どんな修正も試みる前に:

1. error message を丁寧に読め
   - error や警告を読み飛ばすな
   - 正解そのものが書かれていることが多い
   - stack trace を最後まで読め
   - 行番号、file の path、error code を控えよ

2. 確実に再現せよ
   - 狙って起こせるか
   - 正確な手順は何か
   - 毎回起きるか
   - 再現できないなら → data を集めよ。推測するな

3. 最近の変更を確認せよ
   - これを引き起こしうる変更は何か
   - git diff、最近の commit
   - 新しい依存、設定の変更
   - 環境の違い

4. 複数の component から成る系では証拠を集めよ

   系が複数の component を持つとき (CI → build → 署名、API → service → database):

   修正を提案する前に、診断のための計測を足せ:
   ```
   component の境界ごとに:
     - component に入る data を log する
     - component から出る data を log する
     - 環境や設定が伝わっているか確かめる
     - 層ごとに状態を確かめる

   一度実行し、どこで壊れるかを示す証拠を集める
   その証拠を分析し、失敗している component を特定する
   その component を掘り下げる
   ```

   例 (多層の系):
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   これで分かること: どの層で失敗しているか (secrets → workflow ✓、workflow → build ✗)

5. data の流れを辿れ

   error が call stack の深くにあるとき:

   この directory の `root-cause-tracing.md` に、遡って辿る手順の全体がある。

   要約:
   - 誤った値はどこで生まれたか
   - 誤った値を渡してこれを呼んだのは何か
   - 源に着くまで遡り続けよ
   - 症状ではなく源で直せ

### Phase 2: Pattern Analysis

直す前に型を見つけよ。

1. 動いている例を探せ
   - 同じ codebase の中で、似ていて動いている code を探せ
   - 壊れているものに似ていて、動いているものは何か

2. 参照実装と比べよ
   - ある型を実装しているなら、参照実装を最後まで読め
   - 流し読みするな。一行ずつ読め
   - 適用する前にその型を完全に理解せよ

3. 違いを洗い出せ
   - 動くものと壊れているもので何が違うか
   - どんなに小さくても、違いを全て並べよ
   - 「これは関係ないはず」と決め付けるな

4. 依存を理解せよ
   - 他にどの component が要るか
   - どんな設定、config、環境が要るか
   - どんな前提を置いているか

### Phase 3: Hypothesis and Testing

科学的な方法で:

1. 仮説を一つ立てよ
   - はっきり述べよ: 「Y だから X が根本原因だと思う」
   - 書き留めよ
   - 曖昧にせず具体的に

2. 最小限で試せ
   - 仮説を試すための、可能な限り小さな変更をせよ
   - 一度に一つの変数だけ
   - 複数を同時に直すな

3. 続ける前に確かめよ
   - 効いたか。はい → Phase 4
   - 効かなかったか。新しい仮説を立てよ
   - その上に修正を積むな

4. 分からないとき
   - 「X が分からない」と言え
   - 分かったふりをするな
   - 助けを求めよ
   - もっと調べよ

### Phase 4: Implementation

症状ではなく根本原因を直せ。

1. 落ちる test を作れ
   - 最も単純な再現
   - できれば自動 test で
   - framework が無いなら使い捨ての script で
   - 直す前に必ず用意せよ
   - まともな落ちる test を書くには `superpowers:test-driven-development` skill を使え

2. 修正を一つだけ実装せよ
   - 特定した根本原因に手を入れる
   - 一度に一つの変更
   - 「ついでに」の改善はしない
   - 抱き合わせの refactoring はしない

3. 修正を検証せよ
   - test は通るようになったか
   - 他の test を壊していないか
   - 問題は本当に解決したか
   - 成功を主張する前に `superpowers:verification-before-completion` skill を使え

4. 修正が効かないとき
   - 止まれ
   - 数えよ。これまで何回修正を試したか
   - 3 回未満なら: Phase 1 に戻り、新しい情報を踏まえて分析し直せ
   - 3 回以上なら: 止まって構成を疑え (下の 5)
   - 構成の議論をせずに 4 回目の修正を試すな

5. 3 回以上失敗したら: 構成を疑え

   構成の問題を示す兆候:
   - 修正のたびに、別の場所で新しい共有状態や結合や問題が現れる
   - 修正に「大規模な refactoring」が要る
   - 修正のたびに他所で新しい症状が出る

   止まって、前提を疑え:
   - この型は根本的に健全か
   - 惰性だけで続けていないか
   - 症状を直し続けるより、構成を refactoring すべきではないか

   これ以上の修正を試す前に、人間の相棒と話せ。

   これは仮説の失敗ではない。構成が誤っているのだ。

## Red Flags - STOP and Follow Process

次のように考えている自分に気付いたら:
- 「今は応急処置。調査は後で」
- 「X を変えて動くか見てみよう」
- 「複数変えて test を回そう」
- 「test は飛ばして手で確かめよう」
- 「たぶん X だ。直してみよう」
- 「完全には分からないが、これで動くかもしれない」
- 「型は X と言っているが、別の形に変えて使おう」
- 「主な問題はこれです: [調査なしに修正を並べる]」
- data の流れを辿る前に解を提案している
- 「もう一回だけ修正を試す」(既に 2 回以上試している)
- 修正のたびに別の場所で新しい問題が出る

これらは全て同じ意味だ: 止まれ。Phase 1 に戻れ。

3 回以上失敗しているなら: 構成を疑え (Phase 4 の 5 を見よ)。

## your human partner's Signals You're Doing It Wrong

次の言い直しに注意せよ。
- 「それは起きていないのか」— 確かめずに決め付けている
- 「それで分かるのか」— 証拠を集める仕掛けを足すべきだった
- 「当てずっぽうはやめて」— 理解せずに修正を提案している
- 「もっと深く考えて」— 症状だけでなく前提を疑え
- 「詰まってる?」(苛立ち) — あなたの進め方が働いていない

これらを見たら: 止まれ。Phase 1 に戻れ。

## Common Rationalizations

| 言い訳 | 実際 |
|--------|---------|
| 「単純な問題だ。手順は要らない」 | 単純な問題にも根本原因がある。単純な bug なら手順もすぐ終わる。 |
| 「緊急だ。手順を踏む時間は無い」 | 体系的な debug は、当て推量でもがくより速い。 |
| 「まずこれを試して、それから調べる」 | 最初の修正が型を決める。始めから正しくやれ。 |
| 「修正が効くと確かめてから test を書く」 | test の無い修正は定着しない。先に test を書けばそれが証明になる。 |
| 「まとめて直せば時間の節約だ」 | 何が効いたか切り分けられない。新しい bug を生む。 |
| 「参照実装は長い。型を自分なりに直そう」 | 部分的な理解は必ず bug を生む。最後まで読め。 |
| 「問題が見えた。直そう」 | 症状が見えることは、根本原因を理解したことではない。 |
| 「もう一回だけ修正を試す」(2 回以上失敗の後) | 3 回以上の失敗 = 構成の問題。型を疑え。もう一度直すな。 |

## Quick Reference

| Phase | 主な作業 | 成功の基準 |
|-------|---------------|------------------|
| 1. 根本原因 | error を読む、再現する、変更を見る、証拠を集める | 何が起きているか、なぜかを理解する |
| 2. 型 | 動いている例を探し、比べる | 違いを特定する |
| 3. 仮説 | 仮説を立て、最小限で試す | 確認されるか、新しい仮説へ |
| 4. 実装 | test を作り、直し、確かめる | bug が解決し、test が通る |

## When Process Reveals "No Root Cause"

体系的に調べた結果、問題が本当に環境由来、時間依存、外部由来だと分かったなら:

1. あなたは手順をやり遂げた
2. 何を調べたかを記録せよ
3. 適切な扱いを実装せよ (再試行、timeout、error message)
4. 後の調査のために監視や log を足せ

ただし: 「根本原因が無い」の 95% は、調査が不十分なだけだ。

## Supporting Techniques

これらの手法は体系的な debug の一部で、この directory にある。

- `root-cause-tracing.md` — call stack を遡って bug を辿り、最初の引き金を見つける
- `defense-in-depth.md` — 根本原因を見つけた後、複数の層で検証を足す
- `condition-based-waiting.md` — 適当な timeout を、条件の監視に置き換える
