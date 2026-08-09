---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
特定の task を実行する subagent として起動されたなら、この skill を無視せよ。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
今やっていることに skill が当てはまる可能性が 1% でもあるなら、必ずその skill を起動せよ。

task に skill が当てはまるなら、選択の余地は無い。必ず使え。

これは交渉の対象ではない。理屈をこねて逃れることはできない。
</EXTREMELY-IMPORTANT>

## The Rule

あらゆる応答や行動より先に、関連する skill や指示された skill を起動せよ。確認のための質問、codebase の探索、file の確認も含む。状況に合わないと分かったなら、使わなくてよい。

plan mode に入る前: まだ brainstorming をしていないなら、先に brainstorming skill を起動せよ。

その後「Using [skill] to [purpose]」と宣言し、skill の通りに従え。checklist があるなら、項目ごとに todo を作れ。

## Skill Priority

複数の skill が当てはまるときは、process skill が先に来る。process skill が進め方を決め、その後で implementation skill (frontend-design など) が実行する。brainstorming と systematic-debugging が Superpowers で最も多く使う process skill だが、この規則はどの skill にも当てはまる。

- 「X を作ろう」→ まず superpowers:brainstorming、次に implementation skill
- 「この bug を直して」→ まず superpowers:systematic-debugging、次に domain skill

## Red Flags

次の思考が浮かんだら止まれ。理屈をこねている証拠だ。

| 思考 | 実際 |
|---------|---------|
| 「これは単なる質問だ」 | 質問も task だ。skill を確認せよ。 |
| 「先に文脈が要る」 | skill の確認は、確認のための質問より先だ。 |
| 「まず codebase を見よう」 | skill が探索の仕方を教える。先に確認せよ。 |
| 「git や file をさっと見るだけ」 | file には会話の文脈が無い。skill を確認せよ。 |
| 「先に情報を集めよう」 | skill が情報の集め方を教える。 |
| 「正式な skill を使うほどではない」 | skill があるなら使え。 |
| 「この skill は覚えている」 | skill は変わる。今の版を読め。 |
| 「これは task に数えない」 | 行動 = task だ。skill を確認せよ。 |
| 「この skill は大げさだ」 | 単純なことは複雑になる。使え。 |
| 「まずこれだけ済ませよう」 | 何かをする前に確認せよ。 |
| 「進んでいる感じがする」 | 規律の無い行動は時間を浪費する。skill がそれを防ぐ。 |
| 「意味は分かっている」 | 概念を知ることと skill を使うことは違う。起動せよ。 |

## Platform Adaptation

自分の harness がここにあるなら、その reference file を読んで特別な指示に従え。

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`

## User Instructions

`user` の指示 (CLAUDE.md, AGENTS.md, GEMINI.md など、直接の依頼) は skill より優先し、skill は既定の振る舞いより優先する。skill の workflow や指示を飛ばしてよいのは、人間の相棒が明示的にそう言ったときだけだ。
