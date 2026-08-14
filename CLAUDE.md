# CLAUDE.md

Personal dotfiles for macOS and Linux.

## Summary

- `~/dotfils/.config/` 配下を `~/.config/` に symlink して管理
- `install.sh` が OS 検出後、`scripts/{darwin,linux}.sh` を source して環境別にセットアップ
- `~/dotfiles/dot-claude/` を `~/.claude/` にリンクし、Claude Code の設定を dotfiles 管理下に置く

## Environments

- OS: macOS (primary), Linux (secondary)
- Stack: Ghostty → herdr → {nvim, zsh, Claude Code...}
- Terminal: Ghostty
- Multiplexer: herdr
- Shell: zsh
- Filer: yazi
- Diff: hunk
- Editor: Neovim + oil, snacks explorer, snacks terminal
