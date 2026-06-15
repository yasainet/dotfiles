# CLAUDE.md

Personal dotfiles for macOS and Linux.

## Summary

- `.config/` 配下を `~/.config/` にシンボリックリンクして管理
- `install.sh` が OS 検出後、`scripts/{darwin,linux}.sh` を source して環境別セットアップ
- `dot-claude/` を `~/.claude/` にリンクし、Claude Code の設定も dotfiles 管理下に置く
- `nvim`, `zsh`, `Claude Code` は、常に `tmux`, `Ghostty` の上で起動している

## Environments

- OS: macOS (primary), Linux (secondary)
- Terminal: Ghostty
- Shell: Zsh + Pure
- Editor: Neovim + snacks explorer, terminal
- Multiplexer: tmux

## Commands

```sh
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```

> [!NOTE]
> macOS の初回セットアップは事前に App Store と iCloud へサインインすること。
> 未サインインでも install は中断しないが、mas アプリと iCloud Downloads の symlink は生成されない。
> サインイン後に `./install.sh` を再実行すれば冪等に補完される。
