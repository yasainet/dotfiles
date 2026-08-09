# Antigravity CLI (`agy`) Tool Mapping

skill は行動で語る (「subagent を起動する」「todo を作る」「file を読む」)。Antigravity CLI (`agy`) では、これらは以下の tool に対応する。

| skill が求める行動 | Antigravity CLI での対応 |
|----------------------|----------------------|
| subagent の起動 (`Subagent (general-purpose):` template) | 組み込みの `TypeName` を指定した `invoke_subagent` — 全機能の作業なら `self`、read-only なら `research` |
| task 追跡 (「todo を作る」「完了にする」) | task artifact — `write_to_file` に `IsArtifact: true` と `ArtifactType: "task"` を付ける ([Task tracking](#task-tracking) を見よ)。`manage_task` ではない。あれは background process を管理する tool だ。 |

## Task tracking

Antigravity に todo tool は無い (`manage_task` は background process を管理する — `list`/`kill`/`status`/`send_input` — checklist ではない)。skill が todo list を作れ、task を追跡せよと言うときは、task artifact を保て。markdown の checklist を `write_to_file` (`IsArtifact: true`, `ArtifactMetadata.ArtifactType: "task"`) で保存し、進みながら `replace_file_content` / `multi_replace_file_content` で編集する。

複数 step の task を始めるときは、計画の全 step を並べた task artifact を作れ。step を終えるたびに artifact を編集し、完了印を付けよ (`- [x]`)。計画が変わったら checklist を更新せよ。常に最新に保て。残りが何かを示す唯一の拠り所だ。会話が長くなったら、各 step を始める前に読み直せ。
