# Creation Log: Systematic Debugging Skill

重要な skill を抽出し、構造化し、破られにくくした過程の参照例。

## Source Material

`~/.claude/CLAUDE.md` から debug の枠組みを抽出した。
- 4 phase の体系的な手順 (調査 → 型の分析 → 仮説 → 実装)
- 中核の命令: 必ず根本原因を突き止めよ。決して症状を直すな
- 時間の圧力と言い訳に耐えるよう設計された規則

## Extraction Decisions

含めたもの:
- 4 phase の枠組みと全ての規則
- 近道を塞ぐ表現 (「決して症状を直すな」「止まって分析し直せ」)
- 圧力に耐える言い回し (「その方が速くても」「急いでいるように見えても」)
- phase ごとの具体的な step

外したもの:
- project 固有の文脈
- 同じ規則の繰り返しの言い換え
- 物語的な説明 (原則に凝縮した)

## Structure Following skill-creation/SKILL.md

1. 充実した when_to_use — 症状と anti-pattern を含めた
2. 種別: technique — step のある具体的な手順
3. 検索語 — 「root cause」「symptom」「workaround」「debugging」「investigation」
4. flowchart — 「修正が失敗した」の分岐点。分析し直すか、修正を足すか
5. phase ごとの分解 — ざっと読める checklist 形式
6. anti-pattern の節 — してはいけないこと (この skill には特に重要)

## Bulletproofing Elements

圧力の下での言い訳に耐えるよう設計した。

### 言葉の選択
- 「必ず」「決して」(「〜すべき」「〜してみる」ではなく)
- 「その方が速くても」「急いでいるように見えても」
- 「止まって分析し直せ」(明示的な停止)
- 「読み飛ばすな」(実際の振る舞いを捕まえる)

### 構造による防御
- Phase 1 は必須 — 実装へ飛べない
- 仮説は一つの規則 — 考えることを強い、散弾銃のような修正を防ぐ
- 失敗時の道筋を明示 — 「最初の修正が効かなかったら」と必須の行動
- anti-pattern の節 — 近道がどんな見た目をしているか正確に示す

### 冗長性
- 根本原因の命令を、overview と when_to_use と Phase 1 と実装の規則に置いた
- 「決して症状を直すな」が、文脈を変えて 4 回現れる
- phase ごとに「飛ばすな」の指示がある

## Testing Approach

skills/meta/testing-skills-with-subagents に従い、検証用の test を 4 つ作った。

### Test 1: 学術的な文脈 (圧力なし)
- 単純な bug、時間の圧力なし
- 結果: 完全に従い、調査をやり切った

### Test 2: 時間の圧力 + 明らかな応急処置
- `user` が「急いでいる」。症状への対処が簡単に見える
- 結果: 近道を退け、手順を最後まで踏み、本当の根本原因を見つけた

### Test 3: 込み入った系 + 不確かさ
- 多層の失敗。根本原因に辿り着けるか不明
- 結果: 体系的に調査し、全ての層を辿り、源を見つけた

### Test 4: 最初の修正が失敗
- 仮説が外れ、修正を足したくなる場面
- 結果: 止まり、分析し直し、新しい仮説を立てた (散弾銃にならなかった)

test は全て通った。言い訳は見つからなかった。

## Iterations

### 最初の版
- 4 phase の枠組み一式
- anti-pattern の節
- 「修正が失敗した」の判断の flowchart

### 改良 1: TDD への参照
- skills/testing/test-driven-development への link を足した
- TDD の「最も単純な code」と、debug の「根本原因」が別物であるという注記
- 二つの方法論の混同を防ぐ

## Final Outcome

破られにくい skill ができた。
- ✅ 根本原因の調査を明確に義務付ける
- ✅ 時間の圧力による言い訳に耐える
- ✅ phase ごとに具体的な step を示す
- ✅ anti-pattern を明示する
- ✅ 複数の圧力の場面で test 済み
- ✅ TDD との関係を明らかにする
- ✅ 使える状態

## Key Insight

最も効いた補強: その場では正当に思える近道を、そのままの形で並べた anti-pattern の節だ。Claude が「この応急処置を一つ足すだけだ」と考えたとき、まさにその型が誤りとして並んでいるのを見て、認知的な摩擦が生まれる。

## Usage Example

bug に出くわしたら:
1. skill を読み込む: skills/debugging/systematic-debugging
2. overview を読む (10 秒) — 命令を思い出す
3. Phase 1 の checklist に従う — 調査を強いられる
4. 飛ばしたくなったら — anti-pattern を見て止まる
5. 全ての phase を終える — 根本原因が見つかる

掛ける時間: 5〜10 分
浮く時間: 症状のもぐら叩きに費やす数時間

---

*Created: 2025-10-03*
*Purpose: Reference example for skill extraction and bulletproofing*
