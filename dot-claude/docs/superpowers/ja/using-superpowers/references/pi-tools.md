# Pi Tool Mapping

skill は行動で語る (「subagent を起動する」「todo を作る」「file を読む」)。Pi では、これらは以下の tool に対応する。

| skill が求める行動 | Pi での対応 |
| --- | --- |
| subagent の起動 (`Subagent (general-purpose):` template) | `pi-subagents` の `subagent` など、導入済みの subagent tool があれば使う |
| task 追跡 (「todo を作る」「完了にする」) | 導入済みの todo/task tool があれば使う。無ければ計画 file か `TODO.md` で追跡する |

## Subagents

Pi 本体に標準の subagent tool は無い。`pi-subagents` package は有力な追加候補で、`subagent` tool を提供する。単体、chain、並列、非同期、context の分岐、再開/状態確認の workflow に対応する。subagent tool が無いなら、`Task` の呼び出しをでっち上げるな。今の session で順に実行するか、subagent 機能は導入されていないと説明せよ。

## Task lists

Pi 本体に標準の task-list tool は無い。todo/task の拡張が入っているなら、その文書化された tool を使え。無ければ Superpowers の計画 file、Markdown の checklist、repo 内の `TODO.md` で task を追跡せよ。古い Superpowers の文書は `TodoWrite` に言及することがある。それは上記の task 追跡という行動として扱え。
