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
- リポジトリは `~/ghq/github.com/yasainet/dotfiles` に配置（両 OS 共通、`ghq` 管理下）
- `install.sh` は `DOTFILES` をスクリプト自身の場所から自己解決するため、clone 先パスに依存しない

## Commands

```sh
brew install ghq   # macOS、Linux なら sudo apt install ghq
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```

> [!NOTE]
> macOS の初回セットアップは事前に App Store と iCloud へサインインすること。
> 未サインインでも install は中断しないが、mas アプリと iCloud Downloads の symlink は生成されない。
> サインイン後に `./install.sh` を再実行すれば冪等に補完される。

## Verification

```sh
exec zsh
```
