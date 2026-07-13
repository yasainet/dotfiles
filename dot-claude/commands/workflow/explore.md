---
description: タスク開始時に目的を合意し、コードベースを調査して報告する
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), Agent, AskUserQuestion
---

## Phase: Explore

- この command の実行中、ファイルの編集と plan の提案を禁止する
- 成果物は会話に出す調査報告のみとする

## Steps

1. 依頼を一文で言い換え、目的とスコープの認識を示す

2. 目的に曖昧さがある場合のみ、AskUserQuestion で確認する

3. 調査する

   - 広範囲の検索は Explore subagent に委譲し、model を必ず明示する
   - 判断を伴う調査は sonnet、機械的な列挙は haiku を指定する
   - 核心となるファイルだけを自分で読む

4. 調査報告を以下の形式で出す（全体で 25 行以内）

   - 目的: 合意した一文
   - 現状理解: 3〜5 行
   - 関連ファイル: `path:line` 付きの一覧
   - 選択肢と論点: 方針が複数ある場合のみ
   - 未確定事項: 協議が必要な点

5. 次の分岐を提示して終了する

   - 未確定事項がある → 協議を続ける
   - 方針が固まっている → plan mode に切り替えて計画を作成
   - diff を一文で説明できる → plan を省略して直接実装

> [!NOTE]
>
> - 報告の行数上限は厳守せよ、長い調査結果は要点に絞れ
> - plan の中身に踏み込みそうになったら止まれ、それは plan mode の仕事である
