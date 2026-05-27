# CLAUDE.md

Personal dotfiles for macOS and Linux.

## Summary

- `.config/` 配下を `~/.config/` にシンボリックリンクして管理
- `install.sh` が OS 検出後、`scripts/{darwin,linux}.sh` を source して環境別セットアップ
- `dot-claude/` を `~/.claude/` にリンクし、Claude Code の設定も dotfiles 管理下に置く

## Environments

- OS: macOS (primary), Linux (secondary)
- Terminal: Ghostty
- Shell: Zsh + Pure
- Editor: Neovim + snacks explorer, terminal
- Multiplexer: tmux

## Constraints

- 設定ファイルは symlink 方式で管理（`scripts/common.sh:create_symlinks`）。実体は repo に残し、リンク先のみホームに展開
- OS 別処理は `install.sh` から `scripts/{darwin,linux}.sh` を source して切り替え
- espanso は macOS だけ設定パスが `~/.config` 外のため `scripts/darwin.sh:link_espanso` で個別リンク（Linux は既存ループで対応）
- ブラウザ自動化は chrome-devtools MCP（Chrome Canary 利用）で代替。純正 Claude-in-Chrome が接続不可なため。`~/.claude.json` は symlink 管理外なので `scripts/darwin.sh:setup_claude_mcp` が `claude mcp add` で登録する

## Commands

```sh
./install.sh
```

## Verification

```sh
exec zsh
```
