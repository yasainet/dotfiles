# Persuasion Principles for Skill Design

## Overview

LLM は、人間と同じ説得の原則に反応する。この心理を理解すると、より効く skill を設計できる。操るためではなく、圧力の下でも重要な作法が守られるようにするためだ。

研究の基礎: Meincke et al. (2025) は、AI との会話 28,000 件で 7 つの説得の原則を試した。説得の手法は従う割合を倍以上にした (33% → 72%, p < .001)。

## The Seven Principles

### 1. 権威 (Authority)
何か: 専門性、資格、公式の出所への従属。

skill での働き方:
- 命令の言葉: 「必ず」「決して」「常に」
- 交渉の余地を断つ言い回し: 「例外は無い」
- 判断の疲れと言い訳を無くす

使うとき:
- 規律を課す skill (TDD、検証の要件)
- 安全に関わる作法
- 定着した定石

例:
```markdown
✅ Write code before test? Delete it. Start over. No exceptions.
❌ Consider writing tests first when feasible.
```

### 2. 一貫性 (Commitment)
何か: 過去の行動、発言、公にした宣言との一貫性。

skill での働き方:
- 宣言を求める: 「skill の使用を宣言せよ」
- 明示的な選択を強いる: 「A、B、C から選べ」
- 追跡を使う: checklist のための todo

使うとき:
- skill が実際に守られるようにするとき
- 複数 step の過程
- 責任の仕組み

例:
```markdown
✅ When you find a skill, you MUST announce: "I'm using [Skill Name]"
❌ Consider letting your partner know which skill you're using.
```

### 3. 希少性 (Scarcity)
何か: 期限や限られた機会から生まれる切迫感。

skill での働き方:
- 期限のある要件: 「進む前に」
- 順序の依存: 「X の直後に」
- 先延ばしを防ぐ

使うとき:
- 直ちに検証させたいとき
- 時間に敏感な workflow
- 「後でやる」を防ぐとき

例:
```markdown
✅ After completing a task, IMMEDIATELY request code review before proceeding.
❌ You can review code when convenient.
```

### 4. 社会的証明 (Social Proof)
何か: 他者の行動や、普通とされるものへの同調。

skill での働き方:
- 普遍的な型: 「毎回」「常に」
- 失敗の型: 「Y の無い X = 失敗」
- 規範を作る

使うとき:
- 普遍的な作法を書き残すとき
- よくある失敗を警告するとき
- 基準を補強するとき

例:
```markdown
✅ Checklists without todo tracking = steps get skipped. Every time.
❌ Some people find a todo list helpful for checklists.
```

### 5. 一体感 (Unity)
何か: 共有された身元、「私たち」の感覚、内集団への帰属。

skill での働き方:
- 協働の言葉: 「我々の codebase」「我々は同僚だ」
- 共有された目標: 「我々はどちらも品質を望んでいる」

使うとき:
- 協働の workflow
- team の文化を作るとき
- 上下関係のない作法

例:
```markdown
✅ We're colleagues working together. I need your honest technical judgment.
❌ You should probably tell me if I'm wrong.
```

### 6. 返報性 (Reciprocity)
何か: 受けた恩を返す義務感。

働き方:
- 控えめに使え。操られている感じを与えうる
- skill で必要になることは稀だ

避けるとき:
- ほぼ常に (他の原則の方が効く)

### 7. 好意 (Liking)
何か: 好ましい相手に協力したいという傾向。

働き方:
- 従わせるために使うな
- 率直な feedback の文化と衝突する
- 追従を生む

避けるとき:
- 規律を課す場面では常に

## Principle Combinations by Skill Type

| skill の種別 | 使う | 避ける |
|------------|-----|-------|
| 規律を課す | 権威 + 一貫性 + 社会的証明 | 好意、返報性 |
| 手引き/手法 | 控えめな権威 + 一体感 | 強い権威 |
| 協働 | 一体感 + 一貫性 | 権威、好意 |
| 参照 | 明快さだけ | 説得の全て |

## Why This Works: The Psychology

はっきりした線引きは言い訳を減らす:
- 「必ず」は判断の疲れを取り除く
- 絶対的な言葉は「これは例外か」という問いを無くす
- 言い訳への明示的な反論が、具体的な抜け道を塞ぐ

実行の意図が自動的な振る舞いを作る:
- 明確な引き金 + 必要な行動 = 自動的な実行
- 「X のとき Y せよ」は「だいたい Y せよ」より効く
- 従うことの認知の負荷を下げる

LLM は準人間的だ:
- こうした型を含む人間の文章で学習している
- 学習 data では、権威の言葉の後に従う振る舞いが続く
- 一貫性の並び (宣言 → 行動) が頻繁に現れる
- 社会的証明の型 (みんな X する) が規範を作る

## Ethical Use

正当な使い方:
- 重要な作法が守られるようにする
- 効く文書を作る
- 予見できる失敗を防ぐ

不当な使い方:
- 自分の利得のために操る
- 偽の切迫感を作る
- 罪悪感で従わせる

判定: `user` がその手法を完全に理解したとして、それは `user` の本当の利益に資するか。

## Research Citations

Cialdini, R. B. (2021). *Influence: The Psychology of Persuasion (New and Expanded).* Harper Business.
- 説得の 7 つの原則
- 影響力の研究の実証的な基礎

Meincke, L., Shapiro, D., Duckworth, A. L., Mollick, E., Mollick, L., & Cialdini, R. (2025). Call Me A Jerk: Persuading AI to Comply with Objectionable Requests. University of Pennsylvania.
- LLM との会話 28,000 件で 7 つの原則を試した
- 説得の手法で、従う割合が 33% → 72% に増えた
- 権威、一貫性、希少性が最も効いた
- LLM の振る舞いの準人間的な model を裏付けた

## Quick Reference

skill を設計するとき、こう問え。

1. これはどの種別か (規律か、手引きか、参照か)
2. 変えたい振る舞いは何か
3. どの原則が当てはまるか (規律ならたいてい権威 + 一貫性)
4. 組み合わせすぎていないか (7 つ全ては使うな)
5. これは倫理的か (`user` の本当の利益に資するか)
