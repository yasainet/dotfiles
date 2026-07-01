# CLAUDE.md

Personal dotfiles for macOS and Linux.

## Summary

- `.config/` 配下を `~/.config/` にシンボリックリンクして管理
- `install.sh` が OS 検出後、`scripts/{darwin,linux}.sh` を source して環境別セットアップ
- `dot-claude/` を `~/.claude/` にリンクし、Claude Code の設定も dotfiles 管理下に置く

## Environments

- OS: macOS (primary), Linux (secondary)
- Stack: Ghostty → herdr → {nvim, zsh, Claude Code...}（tmux は inert なフォールバック）
- Shell: Zsh + Pure
- Editor: Neovim + snacks explorer, terminal

## Commands

```sh
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```
