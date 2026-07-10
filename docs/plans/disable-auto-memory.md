# Claude Code auto-memory を off にする

## 背景

Claude Code の auto-memory 機能がデメリット過多となったため無効化する。
auto-memory は `~/.claude/projects/*/memory/` 配下に md を蓄積する仕組み。
user / feedback / project / reference の 4 type を保存する。

削除前の蓄積状況:

- `-Users-yasainet-ghq-github-com-yasainet-anglers-jp/memory/` に 9 ファイル
- `-Users-yasainet-ghq-github-com-yasainet-dotfiles/memory/` に 3 ファイル

## 設定の仕組み

Claude Code 2.1.206 のバイナリから確認済み。

- 設定 key は `autoMemoryEnabled` (boolean, optional)
- `settings.autoMemoryEnabled === false` かつ env 未設定で無効化される
- `undefined` の場合は default true として動作する
- description には "for this project" とあるが settings の resolve は user / project / local の 3 層で行われる

## 選択肢

案 A: `.claude/settings.json` (project 直下) に記載する。
効果範囲はこの dotfiles repo のみ。
他 project (anglers-jp 等) では auto-memory が再生成されるため cleanup が空振る。

案 B: `dot-claude/settings.json` (user 全体) に記載する。
効果範囲は全 project、`~/.claude/settings.json` への symlink 経由で反映。
cleanup と組み合わせて再生成も止められる。

案 C: env `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` を export する。
効果範囲はプロセス単位、shell rc 経由で設定。

## 方針

案 B を採用する。

理由は 2 点ある。

- anglers-jp を含め全 project で off にしたい
- cleanup 後の再生成を防ぐには user 単位で off にする必要がある

## 変更内容

`dot-claude/settings.json` の末尾に `"autoMemoryEnabled": false` を追記する。
`~/.claude/settings.json` は symlink 経由で反映される。

## 既存 memory ファイルの cleanup

以下 2 ディレクトリを `rm -rf` で削除する。

- `~/.claude/projects/-Users-yasainet-ghq-github-com-yasainet-anglers-jp/memory/`
- `~/.claude/projects/-Users-yasainet-ghq-github-com-yasainet-dotfiles/memory/`

## 検証

- [ ] `dot-claude/settings.json` 変更後に新セッションを起動
- [ ] system prompt に `# auto memory` セクションが含まれないことを確認
- [ ] system prompt に `MEMORY.md` の内容が含まれないことを確認
- [ ] 「覚えて」等の指示で memory ファイルが再生成されないことを確認
- [ ] anglers-jp 側でも同様に確認

## コミット

変更ファイルは `dot-claude/settings.json`。
ただし当該ファイルには別作業の pre-compact hook 追加も含まれているため分離する。
コミットメッセージ案は `change(claude): auto-memory を無効化`。
