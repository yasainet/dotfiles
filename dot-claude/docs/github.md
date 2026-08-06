# GitHub

GitHub 運用のルールを記述する

## GitHub Flow

- GitHub Flow を採用する
- prod release 前は main へ直接 push してよい

## Commit

body は LLM が why を辿るための記録である

- ドキュメントは現在の姿しか語らない。決定の履歴は body にしか残らない
- A を B に変えた理由が残れば、後から A を拾い直す事故を防げる
- 追記型なので腐らない。`git log`, `git blame` から到達できる

設計判断も body に書け。ADR は採らない

- `docs/decisions/` や `DECISIONS.md` を作るな
- 決定の記録先を 2 つ持つと、必ず片方が更新されなくなる

### Format

```
<type>(<scope>): <subject>

<body>
```

- subject と body の間に空行を 1 行入れよ
- subject は 1 行で完結させよ
- scope は変更したディレクトリ名を書け。複数はカンマで繋げ
- 日本語で書け

type は `add` `change` `remove` `fix` `feat` `docs` `chore` `style` `revert` から選べ

### Body

該当するものだけ書け。無いものは省け

- なぜそうしたか。何の問題を解決したか
- 何を犠牲にしたか
- 却下した案と、その理由
- 検証したこと。実測値、参照した source

### Rules

- diff を読めば分かることを書くな
- 変更ファイルを列挙するな
- 自明な変更は body を省いてよい
