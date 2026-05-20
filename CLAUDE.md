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

## Commands

- `./install.sh`: 全体セットアップ（symlinks → packages → nvm → post_install）

## Verification

- `ls -la ~/.config/` でシンボリックリンクが張られていることを確認
- `exec zsh` で shell をリロード
