# Superpowers Cheat Sheet v6.1.1

## The Basic Workflow

1. brainstorming
2. using-git-worktrees
3. writing-plans
4. subagent-driven-development or executing-plans
5. test-driven-development
6. requesting-code-review
7. finishing-a-development-branch

## Skills

### Skills List

| Category   | Skill                          |
| ---------- | ------------------------------ |
| Workflow   | brainstorming                  |
| Workflow   | writing-plans                  |
| Workflow   | using-git-worktrees            |
| Workflow   | subagent-driven-development    |
| Workflow   | executing-plans                |
| Workflow   | requesting-code-review         |
| Workflow   | receiving-code-review          |
| Workflow   | finishing-a-development-branch |
| Discipline | test-driven-development        |
| Discipline | systematic-debugging           |
| Discipline | verification-before-completion |
| Tactic     | dispatching-parallel-agents    |
| Meta       | using-superpowers              |
| Meta       | writing-skills                 |

### Summary of Skills

#### Workflow

- brainstorming: 機能や設計に着手する前に、意図と要件を対話で掘り下げる
- writing-plans: 仕様や要件を元に、コード着手前の実装プランを書き起こす
- using-git-worktrees: 現ワークスペースから隔離された作業環境を worktree で用意する
- subagent-driven-development: 独立タスクを同一セッション内で subagent に振り分けて実装する
- executing-plans: 別セッションで、レビュー checkpoint 付きでプランを実行する
- requesting-code-review: 完了やマージ前にレビューを要求し、要件充足を検証する
- receiving-code-review: レビュー指摘を、盲従せず技術検証してから対応する
- finishing-a-development-branch: 実装完了後の merge / PR / 破棄など統合方針を選ぶ

#### Discipline

- test-driven-development: 実装コードより先にテストを書く
- systematic-debugging: 修正案を出す前に、バグや異常挙動を体系的に切り分ける
- verification-before-completion: 完了宣言前に検証コマンドを流し、出力で裏付ける

#### Tactic

- dispatching-parallel-agents: 2 つ以上の独立タスクを並列 agent に振り分ける

#### Meta

- using-superpowers: 会話開始時に、skill の発見と適用ルールを確立する
- writing-skills: skill の新規作成、編集、動作確認を行う
