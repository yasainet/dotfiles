# Gemini CLI Tool Mapping

skill は行動で語る (「subagent を起動する」「todo を作る」「file を読む」)。Gemini CLI では、これらは以下の tool に対応する。

| skill が求める行動 | Gemini CLI での対応 |
|----------------------|----------------------|
| file を読む | `read_file` |
| 複数 file を一度に読む | `read_many_files` |
| 新しい file を作る | `write_file` |
| file を編集する | `replace` |
| shell command を実行する | `run_shell_command` |
| file の中身を検索する | `grep_search` |
| 名前で file を探す | `glob` |
| file と subdirectory を並べる | `list_directory` |
| URL を取得する | `web_fetch` |
| web を検索する | `google_web_search` |
| skill を起動する | `activate_skill` |
| subagent の起動 (`Subagent (general-purpose):` template) | `agent_name: "generalist"` を指定した `invoke_agent` (chat 構文 `@generalist` でも呼べる — [Subagent support](#subagent-support) を見よ) |
| 並列での複数起動 | 同じ応答の中で `invoke_agent` を複数回呼ぶ |
| task 追跡 (「todo を作る」「完了にする」) | `write_todos` (状態: pending, in_progress, completed, cancelled, blocked) |

## Instructions file

skill が「instructions file」と言うとき、Gemini CLI ではこれは `GEMINI.md` を指す。Gemini CLI は `GEMINI.md` を階層的に読み込む。global は `~/.gemini/GEMINI.md` に置く。project 単位のものは workspace directory とその親から読む。tool がその directory の file に触れたときは、subdirectory の `GEMINI.md` も読む。

## Personal skills directory

`user` 単位の skill は `~/.gemini/skills/` に置く。`~/.agents/skills/` は runtime 横断の別名だ (Codex と Copilot CLI と共有する)。同じ階層に両方あるなら、`.agents/skills/` が優先される。各 skill は `SKILL.md` (frontmatter に `name` と `description` を持つ) を含む subdirectory だ。

## Subagent support

Gemini CLI は `invoke_agent` tool で subagent を起動する。この tool は `agent_name` と `prompt` を受け取る。同じ起動は chat 構文の近道としても提供されている。`@generalist <prompt>` と打つのは、`agent_name: "generalist"` で `invoke_agent` を呼ぶのと同じだ。組み込みの agent 名には `generalist`, `cli_help`, `codebase_investigator`、そして (browser 機能を有効にすれば) `browser_agent` がある。

skill は `Subagent (general-purpose):` の形で起動し、prompt template file を参照するか (例: `superpowers:subagent-driven-development` の `./implementer-prompt.md`)、その場で prompt を書く。Gemini CLI では次のようになる。

| skill 側の起動の形 | Gemini CLI での対応 |
|---------------------|----------------------|
| `*-prompt.md` template を参照する場合 (implementer, task-reviewer, code-reviewer など) | template を埋め、`agent_name: "generalist"` と埋めた prompt で `invoke_agent` を呼ぶ |
| `superpowers:requesting-code-review` の `./code-reviewer.md` を参照する場合 | `agent_name: "generalist"` と埋めた review template で `invoke_agent` を呼ぶ |
| その場で書いた prompt (template 参照なし) | `agent_name: "generalist"` とその prompt で `invoke_agent` を呼ぶ |

### Prompt filling

skill が渡す prompt template には `{WHAT_WAS_IMPLEMENTED}` や `[FULL TEXT of task]` のような穴がある。全ての穴を埋めてから、完成した prompt を `invoke_agent` に渡せ。prompt template 自体に agent の役割、review の基準、期待する出力形式が書かれている。subagent はそれに従う。

### Parallel dispatch

Gemini CLI は subagent の並列起動に対応する。同じ応答の中で `invoke_agent` を複数回呼べ (または一つの prompt で `@generalist` を複数回使え)。独立した subagent の作業を並列に走らせられる。依存のある task は順に実行せよ。ただし履歴を単純に保つためだけに、独立した subagent の task を直列にするな。

## Additional Gemini CLI tools

以下は Gemini CLI 固有の tool だ。

| Tool | 用途 |
|------|---------|
| `save_memory` (legacy) | `experimental.memoryV2 = false` のとき、session をまたいで事実を残す |
| `get_internal_docs` | Gemini CLI に同梱された文書を引く |
| `ask_user` | 構造化した質問を `user` に投げる (自由記述 / 単一選択 / 複数選択) |
| `enter_plan_mode` / `exit_plan_mode` | read-only の plan mode に出入りする |
| `update_topic` | 今の会話の topic や戦略的意図の metadata を更新する |
| `complete_task` | Gemini の subagent が完了したことを伝え、結果を親 agent に返す |
| `tracker_create_task`, `tracker_update_task`, `tracker_get_task`, `tracker_list_tasks`, `tracker_add_dependency`, `tracker_visualize` | 依存関係と可視化に対応した task tracker |
| `read_mcp_resource`, `list_mcp_resources` | MCP resource への access |
